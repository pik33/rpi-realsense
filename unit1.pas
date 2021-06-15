unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  librealsense2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
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
framebuffer: array[0..63,0..47] of byte;
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

    for y:=0 to 479 do
      for x:=0 to 639 do
        imagedata[x+640*y]:=depth_frame_data[x+640*y];
    form1.button1.caption:=inttostr(kwas);
    form1.button1.refresh;
    form1.image1.refresh;
    application.ProcessMessages;
    rs2_release_frame(frame);
    end;
  rs2_release_frame(frames);
  end;
result:=depth_frame_data;
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

end.

