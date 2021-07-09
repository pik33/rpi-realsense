{ Unit for handling the serial interfaces for Linux and similar Unices.
  (c) 2000 Sebastian Guenther, sg@freepascal.org; modified MarkMLl 2012.
}

unit Serial2;

{$MODE objfpc}
{$H+}
{$PACKRECORDS C}

interface

uses BaseUnix,termio,unix;

type

  TSerialHandle = LongInt;

  TParityType = (NoneParity, OddParity, EvenParity);

  TSerialFlags = set of (RtsCtsFlowControl);

  TSerialState = record
    LineState: LongWord;
    tios: termios;
  end;



  {
      This file is part of the Free Pascal run time library.
      Copyright (c) 1999-2004 by Marco van de Voort
      member of the Free Pascal development team

      ioctls constants for linux

      See the file COPYING.FPC, included in this distribution,
      for details about the copyright.

      This program is distributed in the hope that it will be useful,
      but WITHOUT ANY WARRANTY; without even the implied warranty of
      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

   **********************************************************************}
  {********************
     IOCtl(TermIOS)
  ********************}

  Const
    { Amount of Control Chars }
    NCCS = 32;
    NCC = 8;


    { For Terminal handling }
    TCGETS          = $5401;
    TCSETS          = $5402;
    TCSETSW         = $5403;
    TCSETSF         = $5404;
    TCGETA          = $5405;
    TCSETA          = $5406;
    TCSETAW         = $5407;
    TCSETAF         = $5408;
    TCSBRK          = $5409;
    TCXONC          = $540A;
    TCFLSH          = $540B;
    TIOCEXCL        = $540C;
    TIOCNXCL        = $540D;
    TIOCSCTTY       = $540E;
    TIOCGPGRP       = $540F;
    TIOCSPGRP       = $5410;
    TIOCOUTQ        = $5411;
    TIOCSTI         = $5412;
    TIOCGWINSZ      = $5413;
    TIOCSWINSZ      = $5414;
    TIOCMGET        = $5415;
    TIOCMBIS        = $5416;
    TIOCMBIC        = $5417;
    TIOCMSET        = $5418;
    TIOCGSOFTCAR    = $5419;
    TIOCSSOFTCAR    = $541A;
    FIONREAD        = $541B;
    TIOCINQ         = FIONREAD;
    TIOCLINUX       = $541C;
    TIOCCONS        = $541D;
    TIOCGSERIAL     = $541E;
    TIOCSSERIAL     = $541F;
    TIOCPKT         = $5420;
    FIONBIO         = $5421;
    TIOCNOTTY       = $5422;
    TIOCSETD        = $5423;
    TIOCGETD        = $5424;
    TCSBRKP         = $5425;
    TIOCTTYGSTRUCT  = $5426;
    FIONCLEX        = $5450;
    FIOCLEX         = $5451;
    FIOASYNC        = $5452;
    TIOCSERCONFIG   = $5453;
    TIOCSERGWILD    = $5454;
    TIOCSERSWILD    = $5455;
    TIOCGLCKTRMIOS  = $5456;
    TIOCSLCKTRMIOS  = $5457;
    TIOCSERGSTRUCT  = $5458;
    TIOCSERGETLSR   = $5459;
    TIOCSERGETMULTI = $545A;
    TIOCSERSETMULTI = $545B;

    TIOCMIWAIT      = $545C;
    TIOCGICOUNT     = $545D;
    FIOQSIZE        = $545E;

    TIOCPKT_DATA       = 0;
    TIOCPKT_FLUSHREAD  = 1;
    TIOCPKT_FLUSHWRITE = 2;
    TIOCPKT_STOP       = 4;
    TIOCPKT_START      = 8;
    TIOCPKT_NOSTOP     = 16;
    TIOCPKT_DOSTOP     = 32;

  {c_cc characters}
    VINTR    = 0;
    VQUIT    = 1;
    VERASE   = 2;
    VKILL    = 3;
    VEOF     = 4;
    VTIME    = 5;
    VMIN     = 6;
    VSWTC    = 7;
    VSTART   = 8;
    VSTOP    = 9;
    VSUSP    = 10;
    VEOL     = 11;
    VREPRINT = 12;
    VDISCARD = 13;
    VWERASE  = 14;
    VLNEXT   = 15;
    VEOL2    = 16;

  {c_iflag bits}
     IGNBRK  = $0000001;
     BRKINT  = $0000002;
     IGNPAR  = $0000004;
     PARMRK  = $0000008;
     INPCK   = $0000010;
     ISTRIP  = $0000020;
     INLCR   = $0000040;
     IGNCR   = $0000080;
     ICRNL   = $0000100;
     IUCLC   = $0000200;
     IXON    = $0000400;
     IXANY   = $0000800;
     IXOFF   = $0001000;
     IMAXBEL = $0002000;

  {c_oflag bits}
     OPOST  = $0000001;
     OLCUC  = $0000002;
     ONLCR  = $0000004;
     OCRNL  = $0000008;
     ONOCR  = $0000010;
     ONLRET = $0000020;
     OFILL  = $0000040;
     OFDEL  = $0000080;
     NLDLY  = $0000100;
       NL0  = $0000000;
       NL1  = $0000100;
     CRDLY  = $0000600;
       CR0  = $0000000;
       CR1  = $0000200;
       CR2  = $0000400;
       CR3  = $0000600;
     TABDLY = $0001800;
       TAB0 = $0000000;
       TAB1 = $0000800;
       TAB2 = $0001000;
       TAB3 = $0001800;
      XTABS = $0001800;
     BSDLY  = $0002000;
       BS0  = $0000000;
       BS1  = $0002000;
     VTDLY  = $0004000;
       VT0  = $0000000;
       VT1  = $0004000;
     FFDLY  = $0008000;
       FF0  = $0000000;
       FF1  = $0008000;

  {c_cflag bits}
     CBAUD   = $000100F;
     B0      = $0000000;
     B50     = $0000001;
     B75     = $0000002;
     B110    = $0000003;
     B134    = $0000004;
     B150    = $0000005;
     B200    = $0000006;
     B300    = $0000007;
     B600    = $0000008;
     B1200   = $0000009;
     B1800   = $000000A;
     B2400   = $000000B;
     B4800   = $000000C;
     B9600   = $000000D;
     B19200  = $000000E;
     B38400  = $000000F;
     EXTA    = B19200;
     EXTB    = B38400;
     CSIZE   = $0000030;
       CS5   = $0000000;
       CS6   = $0000010;
       CS7   = $0000020;
       CS8   = $0000030;
     CSTOPB  = $0000040;
     CREAD   = $0000080;
     PARENB  = $0000100;
     PARODD  = $0000200;
     HUPCL   = $0000400;
     CLOCAL  = $0000800;
     CBAUDEX = $0001000;
     B57600  = $0001001;
     B115200 = $0001002;
     B230400 = $0001003;
     B460800 = $0001004;
     B500000 = $0001005;
     B576000 = $0001006;
    B921600  = $0001007;
    B1000000 = $0001008;
    B1152000 = $0001009;
    B1500000 = $000100a;
    B2000000 = $0001013;
    B2500000 = $0001014;
    B3000000 = $0001015;
    B3500000 = $0001016;
    B4000000 = $0001017;
   __MAX_BAUD= B4000000;


     CIBAUD  = $100F0000;
     CMSPAR  = $40000000;
     CRTSCTS = $80000000;

  {c_lflag bits}
     ISIG    = $0000001;
     ICANON  = $0000002;
     XCASE   = $0000004;
     ECHO    = $0000008;
     ECHOE   = $0000010;
     ECHOK   = $0000020;
     ECHONL  = $0000040;
     NOFLSH  = $0000080;
     TOSTOP  = $0000100;
     ECHOCTL = $0000200;
     ECHOPRT = $0000400;
     ECHOKE  = $0000800;
     FLUSHO  = $0001000;
     PENDIN  = $0004000;
     IEXTEN  = $0008000;

  {c_line bits}
     TIOCM_LE   = $001;
     TIOCM_DTR  = $002;
     TIOCM_RTS  = $004;
     TIOCM_ST   = $008;
     TIOCM_SR   = $010;
     TIOCM_CTS  = $020;
     TIOCM_CAR  = $040;
     TIOCM_RNG  = $080;
     TIOCM_DSR  = $100;
     TIOCM_CD   = TIOCM_CAR;
     TIOCM_RI   = TIOCM_RNG;
     TIOCM_OUT1 = $2000;
     TIOCM_OUT2 = $4000;

  {TCSetAttr}
     TCSANOW   = 0;
     TCSADRAIN = 1;
     TCSAFLUSH = 2;

  {TCFlow}
     TCOOFF = 0;
     TCOON  = 1;
     TCIOFF = 2;
     TCION  = 3;

  {TCFlush}
     TCIFLUSH  = 0;
     TCOFLUSH  = 1;
     TCIOFLUSH = 2;


  Type
    winsize = record
      ws_row,
      ws_col,
      ws_xpixel,
      ws_ypixel : word;
    end;
    TWinSize=winsize;

  {$PACKRECORDS C}
    Termios = record
      c_iflag,
      c_oflag,
      c_cflag,
      c_lflag  : cardinal;
      c_line   : char;
      c_cc     : array[0..NCCS-1] of byte;
      c_ispeed,
      c_ospeed : cardinal;
    end;
    TTermios=Termios;
  {$PACKRECORDS Default}




{ Open the serial device with the given device name, for example:
    /dev/ttyS0, /dev/ttyS1... for normal serial ports
    /dev/ttyI0, /dev/ttyI1... for ISDN emulated serial ports
    other device names are possible; refer to your OS documentation.
  Returns "0" if device could not be found }
function SerOpen(const DeviceName: String): TSerialHandle;

{ Closes a serial device previously opened with SerOpen. }
procedure SerClose(Handle: TSerialHandle);

{ Flushes the data queues of the given serial device. DO NOT USE THIS:
  use either SerSync (non-blocking) or SerDrain (blocking). }
procedure SerFlush(Handle: TSerialHandle); deprecated;

{ Suggest to the kernel that buffered output data should be sent. This
  is unlikely to have a useful effect except possibly in the case of
  buggy ports that lose Tx interrupts, and is implemented as a preferred
  alternative to the deprecated SerFlush procedure. }
procedure SerSync(Handle: TSerialHandle);

{ Wait until all buffered output has been transmitted. It is the caller's
  responsibility to ensure that this won't block permanently due to an
  inappropriate handshake state. }
procedure SerDrain(Handle: TSerialHandle);

{ Discard all pending input. }
procedure SerFlushInput(Handle: TSerialHandle);

{ Discard all unsent output. }
procedure SerFlushOutput(Handle: TSerialHandle);

{ Reads a maximum of "Count" bytes of data into the specified buffer.
  Result: Number of bytes read. }
function SerRead(Handle: TSerialHandle; var Buffer; Count: LongInt): LongInt;

{ Tries to write "Count" bytes from "Buffer".
  Result: Number of bytes written. }
function SerWrite(Handle: TSerialHandle; Const Buffer; Count: LongInt): LongInt;

procedure SerSetParams(Handle: TSerialHandle; BitsPerSec: LongInt;
  ByteSize: Integer; Parity: TParityType; StopBits: Integer;
  Flags: TSerialFlags);

{ Saves and restores the state of the serial device. }
function SerSaveState(Handle: TSerialHandle): TSerialState;
procedure SerRestoreState(Handle: TSerialHandle; State: TSerialState);

{ Getting and setting the line states directly. }
procedure SerSetDTR(Handle: TSerialHandle; State: Boolean);
procedure SerSetRTS(Handle: TSerialHandle; State: Boolean);
function SerGetCTS(Handle: TSerialHandle): Boolean;
function SerGetDSR(Handle: TSerialHandle): Boolean;
function SerGetCD(Handle: TSerialHandle): Boolean;
function SerGetRI(Handle: TSerialHandle): Boolean;

{ Set a line break state. If the requested time is greater than zero this is in
  mSec, in the case of unix this is likely to be rounded up to a few hundred
  mSec and to increase by a comparable increment; on unix if the time is less
  than or equal to zero its absolute value will be passed directly to the
  operating system with implementation-specific effect. If the third parameter
  is omitted or true there will be an implicit call of SerDrain() before and
  after the break.

  NOTE THAT on Linux, the only reliable mSec parameter is zero which results in
  a break of around 250 mSec. Might be completely ineffective on Solaris.
 }
procedure SerBreak(Handle: TSerialHandle; mSec: LongInt=0; sync: boolean= true); 

type    TSerialIdle= procedure(h: TSerialHandle);

{ Set this to a shim around Application.ProcessMessages if calling SerReadTimeout(),
  SerBreak() etc. from the main thread so that it doesn't lock up a Lazarus app. }
var     SerialIdle: TSerialIdle= nil;

{ This is similar to SerRead() but adds a mSec timeout. Note that this variant
  returns as soon as a single byte is available, or as dictated by the timeout. }
function SerReadTimeout(Handle: TSerialHandle; var Buffer; mSec: LongInt): LongInt;

{ This is similar to SerRead() but adds a mSec timeout. Note that this variant
  attempts to accumulate as many bytes as are available, but does not exceed
  the timeout. Set up a SerIdle callback if using this in a main thread in a
  Lazarus app. }
function SerReadTimeout(Handle: TSerialHandle; var Buffer: array of byte; count, mSec: LongInt): LongInt;


{ ************************************************************************** }

implementation


function SerOpen(const DeviceName: String): TSerialHandle;
begin
  Result := fpopen(DeviceName, O_RDWR or O_NOCTTY);
end;

procedure SerClose(Handle: TSerialHandle);
begin
  fpClose(Handle);
end;

procedure SerFlush(Handle: TSerialHandle); deprecated;
begin
  fpfsync(Handle);
end;

procedure SerSync(Handle: TSerialHandle);
begin
  fpfsync(Handle)
end;

procedure SerDrain(Handle: TSerialHandle);
begin
  tcdrain(Handle)
end;

procedure SerFlushInput(Handle: TSerialHandle);
begin
  tcflush(Handle, TCIFLUSH)
end;

procedure SerFlushOutput(Handle: TSerialHandle);
begin
  tcflush(Handle, TCOFLUSH)
end;

function SerRead(Handle: TSerialHandle; var Buffer; Count: LongInt): LongInt;
begin
  Result := fpRead(Handle, Buffer, Count);
end;

function SerWrite(Handle: TSerialHandle; Const Buffer; Count: LongInt): LongInt;
begin
  Result := fpWrite(Handle, Buffer, Count);
end;

procedure SerSetParams(Handle: TSerialHandle; BitsPerSec: LongInt;
  ByteSize: Integer; Parity: TParityType; StopBits: Integer;
  Flags: TSerialFlags);
var
  tios: termio.termios;
  q:integer;
begin
  FillChar(tios, SizeOf(tios), #0);

  case BitsPerSec of
    50: tios.c_cflag := B50;
    75: tios.c_cflag := B75;
    110: tios.c_cflag := B110;
    134: tios.c_cflag := B134;
    150: tios.c_cflag := B150;
    200: tios.c_cflag := B200;
    300: tios.c_cflag := B300;
    600: tios.c_cflag := B600;
    1200: tios.c_cflag := B1200;
    1800: tios.c_cflag := B1800;
    2400: tios.c_cflag := B2400;
    4800: tios.c_cflag := B4800;
    19200: tios.c_cflag := B19200;
    38400: tios.c_cflag := B38400;
    57600: tios.c_cflag := B57600;
    115200: tios.c_cflag := B115200;
    230400: tios.c_cflag := B230400;
    460800: tios.c_cflag := B460800;
    500000: tios.c_cflag := B500000;  // 0010005
    576000: tios.c_cflag := B576000;  // 0010006
    921600: tios.c_cflag := B921600;  // 0010007
    1000000:tios.c_cflag := B1000000; // 0010010
    1152000:tios.c_cflag := B1152000; // 0010011
    1500000:tios.c_cflag := B1500000; // 0010012
    2000000:tios.c_cflag := B2000000; // 0010013
    2500000:tios.c_cflag := B2500000; // 0010014
    3000000:tios.c_cflag := B3000000; // 0010015
    3500000:tios.c_cflag := B3500000; // 0010016
    4000000:tios.c_cflag := B4000000; // 0010017
   else tios.c_cflag := B9600;
  end;
{$ifndef SOLARIS}
  tios.c_ispeed := tios.c_cflag;
  tios.c_ospeed := tios.c_ispeed;
{$endif}

  tios.c_cflag := tios.c_cflag or CREAD or CLOCAL;

  case ByteSize of
    5: tios.c_cflag := tios.c_cflag or CS5;
    6: tios.c_cflag := tios.c_cflag or CS6;
    7: tios.c_cflag := tios.c_cflag or CS7;
    else tios.c_cflag := tios.c_cflag or CS8;
  end;

  case Parity of
    OddParity: tios.c_cflag := tios.c_cflag or PARENB or PARODD;
    EvenParity: tios.c_cflag := tios.c_cflag or PARENB;
  end;

  if StopBits = 2 then
    tios.c_cflag := tios.c_cflag or CSTOPB;

  if RtsCtsFlowControl in Flags then
    tios.c_cflag := tios.c_cflag or CRTSCTS;

  tcflush(Handle, TCIOFLUSH);
  q:=tcsetattr(Handle, TCSANOW, tios);
  q:=q;
end;

function SerSaveState(Handle: TSerialHandle): TSerialState;
begin
  fpioctl(Handle, TIOCMGET, @Result.LineState);
//  fpioctl(Handle, TCGETS, @Result.tios);
  TcGetAttr(handle,result.tios);

end;

procedure SerRestoreState(Handle: TSerialHandle; State: TSerialState);
begin
//  fpioctl(Handle, TCSETS, @State.tios);
    TCSetAttr(handle,TCSANOW,State.tios);
    fpioctl(Handle, TIOCMSET, @State.LineState);
end;

procedure SerSetDTR(Handle: TSerialHandle; State: Boolean);
const
  DTR: Cardinal = TIOCM_DTR;
begin
  if State then
    fpioctl(Handle, TIOCMBIS, @DTR)
  else
    fpioctl(Handle, TIOCMBIC, @DTR);
end;

procedure SerSetRTS(Handle: TSerialHandle; State: Boolean);
const
  RTS: Cardinal = TIOCM_RTS;
begin
  if State then
    fpioctl(Handle, TIOCMBIS, @RTS)
  else
    fpioctl(Handle, TIOCMBIC, @RTS);
end;

function SerGetCTS(Handle: TSerialHandle): Boolean;
var
  Flags: Cardinal;
begin
  fpioctl(Handle, TIOCMGET, @Flags);
  Result := (Flags and TIOCM_CTS) <> 0;
end;

function SerGetDSR(Handle: TSerialHandle): Boolean;
var
  Flags: Cardinal;
begin
  fpioctl(Handle, TIOCMGET, @Flags);
  Result := (Flags and TIOCM_DSR) <> 0;
end;

function SerGetCD(Handle: TSerialHandle): Boolean;
var
  Flags: Cardinal;
begin
  fpioctl(Handle, TIOCMGET, @Flags);
  Result := (Flags and TIOCM_CD) <> 0
end;

function SerGetRI(Handle: TSerialHandle): Boolean;
var
  Flags: Cardinal;
begin
  fpioctl(Handle, TIOCMGET, @Flags);
  Result := (Flags and TIOCM_RI) <> 0;
end;

procedure SerBreak(Handle: TSerialHandle; mSec: LongInt= 0; sync: boolean= true);
begin
  if sync then
    tcdrain(Handle);
  if mSec <= 0 then
    tcsendbreak(Handle, Abs(mSec))
  else
    tcsendbreak(Handle, Trunc(mSec / 250));
  if sync then
    tcdrain(Handle)
end; 

function SerReadTimeout(Handle: TSerialHandle; var Buffer; mSec: LongInt): LongInt;

VAR     readSet: TFDSet;
        selectTimeout: TTimeVal;

begin
  fpFD_ZERO(readSet);
  fpFD_SET(Handle, readSet);
  selectTimeout.tv_sec := mSec div 1000;
  selectTimeout.tv_usec := (mSec mod 1000) * 1000;
  result := 0;
  if fpSelect(Handle + 1, @readSet, nil, nil, @selectTimeout) > 0 then
    result := fpRead(Handle, Buffer, 1)
end { SerReadTimeout } ;

{$ifdef LINUX}
  {$define SELECT_UPDATES_TIMEOUT}
{$endif}

{$ifdef SELECT_UPDATES_TIMEOUT}

function SerReadTimeout(Handle: TSerialHandle; var Buffer: array of byte; count, mSec: LongInt): LongInt;

VAR     readSet: TFDSet;
        selectTimeout: TTimeVal;

begin
  fpFD_ZERO(readSet);
  fpFD_SET(Handle, readSet);
  selectTimeout.tv_sec := mSec div 1000;
  selectTimeout.tv_usec := (mSec mod 1000) * 1000;
  result := 0;

// Note: this variant of fpSelect() is a thin wrapper around the kernel's syscall.
// In the case of Linux the syscall DOES update the timeout parameter.

  while fpSelect(Handle + 1, @readSet, nil, nil, @selectTimeout) > 0 do begin
    Inc(result,fpRead(Handle, Buffer[result], count - result));
    if result >= count then
      break;
    if Assigned(SerialIdle) then
      SerialIdle(Handle)
  end
end { SerReadTimeout } ;

{$else}

function SerReadTimeout(Handle: TSerialHandle; var Buffer: array of byte; count, mSec: LongInt): LongInt;

VAR     readSet: TFDSet;
        selectTimeout: TTimeVal;
        uSecOnEntry, uSecElapsed: QWord;

  function now64uSec: QWord;

  var   tv: timeval;

  begin
    fpgettimeofday(@tv, nil);
    result := tv.tv_sec * 1000000 + tv.tv_usec
  end { now64uSec } ;

begin
  fpFD_ZERO(readSet);
  fpFD_SET(Handle, readSet);
  selectTimeout.tv_sec := mSec div 1000;
  selectTimeout.tv_usec := (mSec mod 1000) * 1000;
  result := 0;
  uSecOnEntry := now64uSec;

// Note: this variant of fpSelect() is a thin wrapper around the kernel's syscall.
// In the case of Solaris the syscall DOES NOT update the timeout parameter.

  while fpSelect(Handle + 1, @readSet, nil, nil, @selectTimeout) > 0 do begin
    Inc(result,fpRead(Handle, Buffer[result], count - result));
    uSecElapsed := now64uSec - uSecOnEntry;
    if (result >= count) or (uSecElapsed >= mSec * 1000) then
      break;
    selectTimeout.tv_sec := (mSec * 1000 - uSecElapsed) div 1000000;
    selectTimeout.tv_usec := (mSec * 1000 - uSecElapsed) mod 1000000;
    if Assigned(SerialIdle) then
      SerialIdle(Handle)
  end
end { SerReadTimeout } ;

{$endif}


end.
