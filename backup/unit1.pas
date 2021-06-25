unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  librealsense2, fb, BaseUnix,serial;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

const

STREAM   =        RS2_STREAM_DEPTH;  // rs2_stream is a types of data provided by RealSense device           //
FORMAT   =        RS2_FORMAT_Z16;    // rs2_format identifies how binary data is encoded within a frame      //
WIDTH         =  640;               // Defines the number of columns for each frame or zero for auto resolve//
HEIGHT        =  480;                 // Defines the number of lines for each frame or zero for auto resolve  //
FPS           =  30;                // Defines the rate of frames per second                                //
STREAM_INDEX  =  0;                 // Defines the stream index, used for multiple streams of the same type //
HEIGHT_RATIO  =  20;                // Defines the height ratio between the original frame to the new frame //
WIDTH_RATIO   =  10;

var
Form1: TForm1;

  
pipeline: Prs2_pipeline;
ctx: Prs2_context;
device_list: Prs2_device_list;
config: Prs2_config;
pipeline_profile:Prs2_pipeline_profile;
stream_profile_list: Prs2_stream_profile_list;
stream_profile:Prs2_stream_profile;
stream1: Trs2_stream;
format1: Trs2_format;
index1,unique_id, framerate, width1, height1, rows, row_length, display_size, buffer_size:integer;
buffer:PChar;
aout:PChar;
one_meter:word;
dev: Prs2_device;
fb1: array[0..639,0..479] of word;
framebuffer: array[0..639,0..479] of byte;
fbfd:longint = 0;        // file handle
vinfo:fb_var_screeninfo; // variable screen info.
s2:array[0..31] of byte;
s2w:array[0..15] of word absolute s2;
s2l:array[0..7] of cardinal absolute s2;

serialhandle : LongInt;
ComPortName  : String;
s,tmpstr,txt : String;
ComOut,ComIn : String;
ComPortNr    : integer;
writecount   : integer;
status       : LongInt;

BitsPerSec   : LongInt;
ByteSize     : Integer;
Parity       : TParityType; { TParityType = (NoneParity, OddParity, EvenParity); }
StopBits     : Integer;
Flags        : TSerialFlags; { TSerialFlags = set of (RtsCtsFlowControl); }


ErrorCode    : Integer;
 i,il,fh:integer;
 f:textfile;
  b:char;
{$R *.lfm}

{ TForm1 }

implementation



function get_depth_unit_value(dev:Prs2_device): double;

var e:Trs2_error;
    sensor_list: Prs2_sensor_list;
    num_of_sensors:integer;
    depth_scale:double;
    is_depth_sensor_found:integer;
    i:integer;
    sensor:Prs2_sensor;

begin
e := nil;
sensor_list := rs2_query_sensors(dev, @e);
num_of_sensors := rs2_get_sensors_count(sensor_list, @e);
depth_scale := 0;
is_depth_sensor_found := 0;
for i:= 0 to num_of_sensors do
  begin
  sensor := rs2_create_sensor(sensor_list, i, @e);
  is_depth_sensor_found := rs2_is_sensor_extendable_to(sensor, RS2_EXTENSION_DEPTH_SENSOR, @e);
  if (1 = is_depth_sensor_found) then
    begin
    depth_scale := rs2_get_option(Prs2_options(sensor), RS2_OPTION_DEPTH_UNITS, @e);
    rs2_delete_sensor(sensor);
    break;
    end;
  rs2_delete_sensor(sensor);
  end;
rs2_delete_sensor_list(sensor_list);
if (0 = is_depth_sensor_found) then result:=0
else result:=depth_scale;
end;


function init1(dummy:integer):integer;


var e:Prs2_error;
    e1:integer;
    dev_count:integer;
    aunit:double;
    v:integer;
    b:boolean;

begin
e := nil;
b:= initLibRealsense2('librealsense2.so');
v:=rs2_api_version;
ctx := rs2_create_context(v, @e);
v:=integer(ctx);
device_list := rs2_query_devices(ctx, @e);
dev_count := rs2_get_device_count(device_list, @e);
dev := rs2_create_device(device_list, 0, @e);
aunit := get_depth_unit_value(dev);
one_meter := word(round(1.0 / aunit));
pipeline :=  rs2_create_pipeline(ctx, @e);
config := rs2_create_config(@e);
rs2_config_enable_stream(config, STREAM, STREAM_INDEX, WIDTH, HEIGHT, FORMAT, FPS, @e);
pipeline_profile := rs2_pipeline_start_with_config(pipeline, config, @e);
stream_profile_list := rs2_pipeline_profile_get_streams(pipeline_profile, @e);
stream_profile := Prs2_stream_profile(rs2_get_stream_profile(stream_profile_list, 0, @e));
rs2_get_stream_profile_data(stream_profile, @stream1, @format1,  @index1, @unique_id, @framerate, @e);
rs2_get_video_stream_resolution(stream_profile, @width1, @height1, @e);
rows := height1 div HEIGHT_RATIO;
row_length := width1 div WIDTH_RATIO;
display_size := (rows + 1) * (row_length + 1);
buffer_size := display_size * sizeof(char);
buffer := getmem(display_size);
aout := nil;
e1 := integer(@e);
result:=e1;
fbfd := fpopen('/dev/fb0', O_RDWR);
fpioctl(fbfd, FBIOGET_VSCREENINFO, @vinfo);

end;


function depth(dummy:integer):pointer;

var e:Prs2_error;
    kwas:integer;
    frames:Prs2_frame;
    num_of_frames:integer;
    x,y,i,ii:integer;
    frame:Prs2_frame;
    depth_frame_data:PWord;
    coverage:PInteger;
    coverage_index:integer;
    adepth:integer;
    pixels:PChar;
    pixel_index:integer;
    imagedata:PCardinal;
      px:integer;   q:integer;

      x1,y1,x2,y2,qq,qq2:integer;
begin
e := nil;
form1.image1.picture.loadfromfile('./blank.jpg');
imagedata:=PCardinal( form1.image1.Picture.Bitmap.RawImage.Data);
for kwas:=0 to 1000 do
  begin
  frames := rs2_pipeline_wait_for_frames(pipeline, RS2_DEFAULT_TIMEOUT, @e);
  num_of_frames := rs2_embedded_frames_count(frames, @e);
  for i := 0 to num_of_frames-1 do
    begin
    frame := rs2_extract_frame(frames, i, @e);
    if (0 = rs2_is_frame_extendable_to(frame, RS2_EXTENSION_DEPTH_FRAME, @e))  then
      begin
      rs2_release_frame(frame);
      continue;
      end;
    depth_frame_data := PWord(rs2_get_frame_data(frame, @e));
    for y1:=0 to 29 do //640/16
      begin
      for x1:=0 to 39 do
        begin
        qq2:=0;
        for y2:=0 to 15 do
          for x2:=0 to 15 do
            begin
            qq:= depth_frame_data[10240*y1+640*y2+16*x1+x2];
            if qq > qq2 then qq2:=qq;
           qq2:=(qq2 shr 6);   if qq2>255 then qq2:=255;
             qq2:=qq2+qq2 shl 8 + qq2 shl 16 + qq2 shl 24;
             qq2:=255 shl 16;
            end;
        fplseek(fbfd,4*1920*y1+4*x1,seek_set);
        fpwrite(fbfd,qq2,4);
   //     write(inttohex(qq2,4),' ');
        end;
  //   writeln;
      end;
  //    begin
      //fplseek(fbfd,4*1920*y,seek_set);
 //     for x:=0 to 639  do
 //       begin
 //       q:=(depth_frame_data+640*y+x)^ shr 5;
 //      if q>255  then q:=255;
 //      q:=q*$1010101;
   //      px:=32768 div q;
   //     px:=px+px shl 8 + px shl 16;
 //       fpwrite(fbfd,q,4);
 //       end;

    form1.button1.caption:=inttostr(kwas);
    form1.button1.refresh;
    form1.image1.refresh;
    application.ProcessMessages;
    rs2_release_frame(frame);
    end;
  rs2_release_frame(frames);
  end;
//result:=depth_frame_data;
end;


function exit1(dummy:integer):integer;

var e:Trs2_error;

begin
e := nil;

rs2_pipeline_stop(pipeline, @e);
freemem(buffer);
rs2_delete_pipeline_profile(pipeline_profile);
rs2_delete_stream_profiles_list(stream_profile_list);
rs2_delete_config(config);
rs2_delete_pipeline(pipeline);
rs2_delete_device(dev);
rs2_delete_device_list(device_list);
rs2_delete_context(ctx);
result:=1;
end;








procedure TForm1.Button1Click(Sender: TObject);

var test:integer;

begin
  button1.Caption:='Initializing';
  init1(0);
  application.processmessages;
  button1.caption:='Capturing';
  test:=integer(depth(0));
  application.processmessages;
  exit1(0);
  button1.caption:=inttohex(test,8);
end;

procedure TForm1.Button2Click(Sender: TObject);



begin

ComPortName:= '/dev/ttyAMA1';
serialhandle := SerOpen(ComPortName);
Flags:= [ ]; // None
SerSetParams(serialhandle,230400,8,NoneParity,1,Flags);

s2[0]:=$01 ;
s2[1]:=$FF ;
s2[2]:=$02 ;
s2[3]:=$FE ;
SerWrite(serialhandle, s2, 8);

end;

end.
(*

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  serial, crt;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}


{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);


VAR
   serialhandle : LongInt;
   ComPortName  : String;
   s,tmpstr,txt : String;
   ComOut,ComIn : String;
   ComPortNr    : integer;
   writecount   : integer;
   status       : LongInt;

   BitsPerSec   : LongInt;
   ByteSize     : Integer;
   Parity       : TParityType; { TParityType = (NoneParity, OddParity, EvenParity); }
   StopBits     : Integer;
   Flags        : TSerialFlags; { TSerialFlags = set of (RtsCtsFlowControl); }
     s2:array[0..31] of byte;

   ErrorCode    : Integer;
    i,il,fh:integer;
    f:textfile;
     b:char;

begin
form1.refresh;
sleep( 1000);
application.processmessages;
s:=#$38+#$61+#$61+#$FF;
s2[0]:=$55; s2[1]:=$AA; s2[2]:=$F0; s2[3]:=$0F;
ComPortName:= '/dev/ttyAMA1';
serialhandle := SerOpen(ComPortName);
Flags:= [ ]; // None
SerSetParams(serialhandle,115200,8,NoneParity,1,Flags);
//fh:=fileopen('/dev/input/js0',$40)  ;
repeat
  application.processmessages
  sleep(1000)
until fileexists('/dev/input/js0');


assignfile(f,'/dev/input/js0');
reset(f);
s2[0]:=$01 ;
s2[1]:=$FF ;
s2[2]:=$02 ;
s2[3]:=$FE ;
SerWrite(serialhandle, s2, 8);


repeat
  for i:=0 to 7 do
    begin
    read(f,b);
    s2[i+4]:=byte(b);
    end;

 // memo1.lines.add (inttostr(il)); memo1.lines.add(inttostr(s2[0]) );  application.processmessages;
  status := SerWrite(serialhandle, s2, 12);
  form1.refresh;
  application.processmessages;
  until false;
if status > 0 then
  begin
  { wait for an answer }
  s:='';
  ComIn:='';
  while (Length(Comin)<10) do
    begin
    status:= SerRead(serialhandle, s[1], 10);
    if (s[1]=#13) then status:=-1; { CR => end serial read }
    if (status>0) then ComIn:=ComIn+s[1];
    end;
  end
else
  button1.caption:=inttostr(serialhandle);

SerSync(serialhandle); { flush out any remaining before closure }
SerFlushOutput(serialhandle); { discard any remaining output }
SerClose(serialhandle);

*)

