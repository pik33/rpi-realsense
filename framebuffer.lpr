program framebuffer;
{$mode delphi}{$H+}
uses
  BaseUnix,fb;
var
  fbfd:longint = 0;        // file handle
  vinfo:fb_var_screeninfo; // variable screen info.
  buf:array[0..999999] of byte;
begin
  // Open the framebuffer device file for reading and writing
  fbfd := fpopen('/dev/fb0', O_RDWR);
  if fbfd = -1 then
  begin
    writeln('Error: cannot open framebuffer device.');
    Halt(1)
  end;
  // get variable screen info
  if fpioctl(fbfd, FBIOGET_VSCREENINFO, @vinfo) <> 0 then
  begin
    writeln('Error reading variable screen info.');
    Halt(2);
  end;
  writeln('Display info ',vinfo.xres,'x',vinfo.yres,' bpp ', vinfo.bits_per_pixel);
  fpwrite(fbfd,buf,1000000);
  fpclose(fbfd);
end.
