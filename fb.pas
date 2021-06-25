unit fb;
interface
{ 
 Linux framebuffer unit 
 TODO: convert the IOW (ioctl) macro to function
 2020, Thaddy de Koning
}
{
  Automatically converted by H2Pas 1.0.0 from /usr/include/linux/fb.h
  The following command line parameters were used:
    -o
    /home/asta/fb.pas
    /usr/include/linux/fb.h
}

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


  { Definitions of frame buffers						 }
  { sufficient for now  }

  const
    FB_MAX = 32;    
  { ioctls
     0x46 is 'F'								 }
    FBIOGET_VSCREENINFO = $4600;    
    FBIOPUT_VSCREENINFO = $4601;    
    FBIOGET_FSCREENINFO = $4602;    
    FBIOGETCMAP = $4604;    
    FBIOPUTCMAP = $4605;    
    FBIOPAN_DISPLAY = $4606;    
(* error 
#define FBIO_CURSOR            _IOWR('F', 0x08, struct fb_cursor)
in define line 20 *)
    { 0x4607-0x460B are defined below  }
    { #define FBIOGET_MONITORSPEC	0x460C  }
    { #define FBIOPUT_MONITORSPEC	0x460D  }
    { #define FBIOSWITCH_MONIBIT	0x460E  }
      FBIOGET_CON2FBMAP = $460F;      
      FBIOPUT_CON2FBMAP = $4610;      
    { arg: 0 or vesa level + 1  }
      FBIOBLANK = $4611;      
(* error 
#define FBIOGET_VBLANK		_IOR('F', 0x12, struct fb_vblank)
in define line 28 *)
      FBIO_ALLOC = $4613;      
      FBIO_FREE = $4614;      
      FBIOGET_GLYPH = $4615;      
      FBIOGET_HWCINFO = $4616;      
      FBIOPUT_MODEINFO = $4617;      
      FBIOGET_DISPINFO = $4618;      

    { was #define dname def_expr }
    function FBIO_WAITFORVSYNC : longint; { return type might be wrong }

  { Packed Pixels	 }
  const
    FB_TYPE_PACKED_PIXELS = 0;    
  { Non interleaved planes  }
    FB_TYPE_PLANES = 1;    
  { Interleaved planes	 }
    FB_TYPE_INTERLEAVED_PLANES = 2;    
  { Text/attributes	 }
    FB_TYPE_TEXT = 3;    
  { EGA/VGA planes	 }
    FB_TYPE_VGA_PLANES = 4;    
  { Type identified by a V4L2 FOURCC  }
    FB_TYPE_FOURCC = 5;    
  { Monochrome text  }
    FB_AUX_TEXT_MDA = 0;    
  { CGA/EGA/VGA Color text  }
    FB_AUX_TEXT_CGA = 1;    
  { S3 MMIO fasttext  }
    FB_AUX_TEXT_S3_MMIO = 2;    
  { MGA Millenium I: text, attr, 14 reserved bytes  }
    FB_AUX_TEXT_MGA_STEP16 = 3;    
  { other MGAs:      text, attr,  6 reserved bytes  }
    FB_AUX_TEXT_MGA_STEP8 = 4;    
  { 8-15: SVGA tileblit compatible modes  }
    FB_AUX_TEXT_SVGA_GROUP = 8;    
  { lower three bits says step  }
    FB_AUX_TEXT_SVGA_MASK = 7;    
  { SVGA text mode:  text, attr  }
    FB_AUX_TEXT_SVGA_STEP2 = 8;    
  { SVGA text mode:  text, attr,  2 reserved bytes  }
    FB_AUX_TEXT_SVGA_STEP4 = 9;    
  { SVGA text mode:  text, attr,  6 reserved bytes  }
    FB_AUX_TEXT_SVGA_STEP8 = 10;    
  { SVGA text mode:  text, attr, 14 reserved bytes  }
    FB_AUX_TEXT_SVGA_STEP16 = 11;    
  { reserved up to 15  }
    FB_AUX_TEXT_SVGA_LAST = 15;    
  { 16 color planes (EGA/VGA)  }
    FB_AUX_VGA_PLANES_VGA4 = 0;    
  { CFB4 in planes (VGA)  }
    FB_AUX_VGA_PLANES_CFB4 = 1;    
  { CFB8 in planes (VGA)  }
    FB_AUX_VGA_PLANES_CFB8 = 2;    
  { Monochr. 1=Black 0=White  }
    FB_VISUAL_MONO01 = 0;    
  { Monochr. 1=White 0=Black  }
    FB_VISUAL_MONO10 = 1;    
  { True color	 }
    FB_VISUAL_TRUECOLOR = 2;    
  { Pseudo color (like atari)  }
    FB_VISUAL_PSEUDOCOLOR = 3;    
  { Direct color  }
    FB_VISUAL_DIRECTCOLOR = 4;    
  { Pseudo color readonly  }
    FB_VISUAL_STATIC_PSEUDOCOLOR = 5;    
  { Visual identified by a V4L2 FOURCC  }
    FB_VISUAL_FOURCC = 6;    
  { no hardware accelerator	 }
    FB_ACCEL_NONE = 0;    
  { Atari Blitter		 }
    FB_ACCEL_ATARIBLITT = 1;    
  { Amiga Blitter                 }
    FB_ACCEL_AMIGABLITT = 2;    
  { Cybervision64 (S3 Trio64)     }
    FB_ACCEL_S3_TRIO64 = 3;    
  { RetinaZ3 (NCR 77C32BLT)       }
    FB_ACCEL_NCR_77C32BLT = 4;    
  { Cybervision64/3D (S3 ViRGE)	 }
    FB_ACCEL_S3_VIRGE = 5;    
  { ATI Mach 64GX family		 }
    FB_ACCEL_ATI_MACH64GX = 6;    
  { DEC 21030 TGA		 }
    FB_ACCEL_DEC_TGA = 7;    
  { ATI Mach 64CT family		 }
    FB_ACCEL_ATI_MACH64CT = 8;    
  { ATI Mach 64CT family VT class  }
    FB_ACCEL_ATI_MACH64VT = 9;    
  { ATI Mach 64CT family GT class  }
    FB_ACCEL_ATI_MACH64GT = 10;    
  { Sun Creator/Creator3D	 }
    FB_ACCEL_SUN_CREATOR = 11;    
  { Sun cg6			 }
    FB_ACCEL_SUN_CGSIX = 12;    
  { Sun leo/zx			 }
    FB_ACCEL_SUN_LEO = 13;    
  { IMS Twin Turbo		 }
    FB_ACCEL_IMS_TWINTURBO = 14;    
  { 3Dlabs Permedia 2		 }
    FB_ACCEL_3DLABS_PERMEDIA2 = 15;    
  { Matrox MGA2064W (Millenium)	 }
    FB_ACCEL_MATROX_MGA2064W = 16;    
  { Matrox MGA1064SG (Mystique)	 }
    FB_ACCEL_MATROX_MGA1064SG = 17;    
  { Matrox MGA2164W (Millenium II)  }
    FB_ACCEL_MATROX_MGA2164W = 18;    
  { Matrox MGA2164W (Millenium II)  }
    FB_ACCEL_MATROX_MGA2164W_AGP = 19;    
  { Matrox G100 (Productiva G100)  }
    FB_ACCEL_MATROX_MGAG100 = 20;    
  { Matrox G200 (Myst, Mill, ...)  }
    FB_ACCEL_MATROX_MGAG200 = 21;    
  { Sun cgfourteen		  }
    FB_ACCEL_SUN_CG14 = 22;    
  { Sun bwtwo			 }
    FB_ACCEL_SUN_BWTWO = 23;    
  { Sun cgthree			 }
    FB_ACCEL_SUN_CGTHREE = 24;    
  { Sun tcx			 }
    FB_ACCEL_SUN_TCX = 25;    
  { Matrox G400			 }
    FB_ACCEL_MATROX_MGAG400 = 26;    
  { nVidia RIVA 128               }
    FB_ACCEL_NV3 = 27;    
  { nVidia RIVA TNT		 }
    FB_ACCEL_NV4 = 28;    
  { nVidia RIVA TNT2		 }
    FB_ACCEL_NV5 = 29;    
  { C&T 6555x			 }
    FB_ACCEL_CT_6555x = 30;    
  { 3Dfx Banshee			 }
    FB_ACCEL_3DFX_BANSHEE = 31;    
  { ATI Rage128 family		 }
    FB_ACCEL_ATI_RAGE128 = 32;    
  { CyberPro 2000		 }
    FB_ACCEL_IGS_CYBER2000 = 33;    
  { CyberPro 2010		 }
    FB_ACCEL_IGS_CYBER2010 = 34;    
  { CyberPro 5000		 }
    FB_ACCEL_IGS_CYBER5000 = 35;    
  { SiS 300/630/540               }
    FB_ACCEL_SIS_GLAMOUR = 36;    
  { 3Dlabs Permedia 3		 }
    FB_ACCEL_3DLABS_PERMEDIA3 = 37;    
  { ATI Radeon family		 }
    FB_ACCEL_ATI_RADEON = 38;    
  { Intel 810/815                 }
    FB_ACCEL_I810 = 39;    
  { SiS 315, 650, 740		 }
    FB_ACCEL_SIS_GLAMOUR_2 = 40;    
  { SiS 330 ("Xabre")		 }
    FB_ACCEL_SIS_XABRE = 41;    
  { Intel 830M/845G/85x/865G      }
    FB_ACCEL_I830 = 42;    
  { nVidia Arch 10                }
    FB_ACCEL_NV_10 = 43;    
  { nVidia Arch 20                }
    FB_ACCEL_NV_20 = 44;    
  { nVidia Arch 30                }
    FB_ACCEL_NV_30 = 45;    
  { nVidia Arch 40                }
    FB_ACCEL_NV_40 = 46;    
  { XGI Volari V3XT, V5, V8       }
    FB_ACCEL_XGI_VOLARI_V = 47;    
  { XGI Volari Z7                 }
    FB_ACCEL_XGI_VOLARI_Z = 48;    
  { TI OMAP16xx                   }
    FB_ACCEL_OMAP1610 = 49;    
  { Trident TGUI			 }
    FB_ACCEL_TRIDENT_TGUI = 50;    
  { Trident 3DImage		 }
    FB_ACCEL_TRIDENT_3DIMAGE = 51;    
  { Trident Blade3D		 }
    FB_ACCEL_TRIDENT_BLADE3D = 52;    
  { Trident BladeXP		 }
    FB_ACCEL_TRIDENT_BLADEXP = 53;    
  { Cirrus Logic 543x/544x/5480	 }
    FB_ACCEL_CIRRUS_ALPINE = 53;    
  { NeoMagic NM2070               }
    FB_ACCEL_NEOMAGIC_NM2070 = 90;    
  { NeoMagic NM2090               }
    FB_ACCEL_NEOMAGIC_NM2090 = 91;    
  { NeoMagic NM2093               }
    FB_ACCEL_NEOMAGIC_NM2093 = 92;    
  { NeoMagic NM2097               }
    FB_ACCEL_NEOMAGIC_NM2097 = 93;    
  { NeoMagic NM2160               }
    FB_ACCEL_NEOMAGIC_NM2160 = 94;    
  { NeoMagic NM2200               }
    FB_ACCEL_NEOMAGIC_NM2200 = 95;    
  { NeoMagic NM2230               }
    FB_ACCEL_NEOMAGIC_NM2230 = 96;    
  { NeoMagic NM2360               }
    FB_ACCEL_NEOMAGIC_NM2360 = 97;    
  { NeoMagic NM2380               }
    FB_ACCEL_NEOMAGIC_NM2380 = 98;    
  { PXA3xx			 }
    FB_ACCEL_PXA3XX = 99;    
  { S3 Savage4                    }
    FB_ACCEL_SAVAGE4 = $80;    
  { S3 Savage3D                   }
    FB_ACCEL_SAVAGE3D = $81;    
  { S3 Savage3D-MV                }
    FB_ACCEL_SAVAGE3D_MV = $82;    
  { S3 Savage2000                 }
    FB_ACCEL_SAVAGE2000 = $83;    
  { S3 Savage/MX-MV               }
    FB_ACCEL_SAVAGE_MX_MV = $84;    
  { S3 Savage/MX                  }
    FB_ACCEL_SAVAGE_MX = $85;    
  { S3 Savage/IX-MV               }
    FB_ACCEL_SAVAGE_IX_MV = $86;    
  { S3 Savage/IX                  }
    FB_ACCEL_SAVAGE_IX = $87;    
  { S3 ProSavage PM133            }
    FB_ACCEL_PROSAVAGE_PM = $88;    
  { S3 ProSavage KM133            }
    FB_ACCEL_PROSAVAGE_KM = $89;    
  { S3 Twister                    }
    FB_ACCEL_S3TWISTER_P = $8a;    
  { S3 TwisterK                   }
    FB_ACCEL_S3TWISTER_K = $8b;    
  { S3 Supersavage                }
    FB_ACCEL_SUPERSAVAGE = $8c;    
  { S3 ProSavage DDR              }
    FB_ACCEL_PROSAVAGE_DDR = $8d;    
  { S3 ProSavage DDR-K            }
    FB_ACCEL_PROSAVAGE_DDRK = $8e;    
  { PKUnity-v3 Unigfx		 }
    FB_ACCEL_PUV3_UNIGFX = $a0;    
  { Device supports FOURCC-based formats  }
    FB_CAP_FOURCC = 1;    
  { identification string eg "TT Builtin"  }
  { Start of frame buffer mem  }
  { (physical address)  }
  { Length of frame buffer mem  }
  { see FB_TYPE_*		 }
  { Interleave for interleaved Planes  }
  { see FB_VISUAL_*		 }  { zero if no hardware panning   }
  { zero if no hardware panning   }
  { zero if no hardware ywrap     }
  { length of a line in bytes     }
  { Start of Memory Mapped I/O    }
  { (physical address)  }
  { Length of Memory Mapped I/O   }
  { Indicate to driver which	 }
  {  specific chip/card we have	 }
  { see FB_CAP_*			 }
  { Reserved for future compatibility  }

  type
    fb_fix_screeninfo = record
        id : array[0..15] of char;
        smem_start : dword;
        smem_len : Uint32;
        _type : Uint32;
        type_aux : Uint32;
        visual : Uint32;
        xpanstep : Uint16;
        ypanstep : Uint16;
        ywrapstep : Uint16;
        line_length : Uint32;
        mmio_start : dword;
        mmio_len : Uint32;
        accel : Uint32;
        capabilities : Uint16;
        reserved : array[0..1] of Uint16;
      end;

  { Interpretation of offset for color fields: All offsets are from the right,
   * inside a "pixel" value, which is exactly 'bits_per_pixel' wide (means: you
   * can use the offset as right argument to <<). A pixel afterwards is a bit
   * stream and is written to video memory as that unmodified.
   *
   * For pseudocolor: offset and length should be the same for all color
   * components. Offset specifies the position of the least significant bit
   * of the pallette index in a pixel value. Length indicates the number
   * of available palette entries (i.e. # of entries = 1 << length).
    }
  { beginning of bitfield	 }
  { length of bitfield		 }
  { != 0 : Most significant bit is  }  { right  }    fb_bitfield = record
        offset : Uint32;
        length : Uint32;
        msb_right : Uint32;
      end;

  { Hold-And-Modify (HAM)         }

  const
    FB_NONSTD_HAM = 1;    
  { order of pixels in each byte is reversed  }
    FB_NONSTD_REV_PIX_IN_B = 2;    
  { set values immediately (or vbl) }
    FB_ACTIVATE_NOW = 0;    
  { activate on next open	 }
    FB_ACTIVATE_NXTOPEN = 1;    
  { don't set, round up impossible  }
    FB_ACTIVATE_TEST = 2;    
    FB_ACTIVATE_MASK = 15;    
  { values			 }
  { activate values on next vbl   }
    FB_ACTIVATE_VBL = 16;    
  { change colormap on vbl	 }
    FB_CHANGE_CMAP_VBL = 32;    
  { change all VCs on this fb	 }
    FB_ACTIVATE_ALL = 64;    
  { force apply even when no change }
    FB_ACTIVATE_FORCE = 128;    
  { invalidate videomode  }
    FB_ACTIVATE_INV_MODE = 256;    
  { (OBSOLETE) see fb_info.flags and vc_mode  }
    FB_ACCELF_TEXT = 1;    
  { horizontal sync high active	 }
    FB_SYNC_HOR_HIGH_ACT = 1;    
  { vertical sync high active	 }
    FB_SYNC_VERT_HIGH_ACT = 2;    
  { external sync		 }
    FB_SYNC_EXT = 4;    
  { composite sync high active    }
    FB_SYNC_COMP_HIGH_ACT = 8;    
  { broadcast video timings       }
    FB_SYNC_BROADCAST = 16;    
  { vtotal = 144d/288n/576i => PAL   }
  { vtotal = 121d/242n/484i => NTSC  }
  { sync on green  }
    FB_SYNC_ON_GREEN = 32;    
  { non interlaced  }
    FB_VMODE_NONINTERLACED = 0;    
  { interlaced	 }
    FB_VMODE_INTERLACED = 1;    
  { double scan  }
    FB_VMODE_DOUBLE = 2;    
  { interlaced: top line first  }
    FB_VMODE_ODD_FLD_FIRST = 4;    
    FB_VMODE_MASK = 255;    
  { ywrap instead of panning      }
    FB_VMODE_YWRAP = 256;    
  { smooth xpan possible (internally used)  }
    FB_VMODE_SMOOTH_XPAN = 512;    
  { don't update x/yoffset	 }
    FB_VMODE_CONUPDATE = 512;    
  {
   * Display rotation support
    }
    FB_ROTATE_UR = 0;    
    FB_ROTATE_CW = 1;    
    FB_ROTATE_UD = 2;    
    FB_ROTATE_CCW = 3;    
  { was #define dname(params) para_def_expr }
  { argument types are unknown }
  { return type might be wrong }   

  function PICOS2KHZ(a : longint) : longint;  

  { was #define dname(params) para_def_expr }
  { argument types are unknown }
  { return type might be wrong }   
  function KHZ2PICOS(a : longint) : longint;  

  { visible resolution		 }
  { virtual resolution		 }
  { offset from virtual to visible  }
  { resolution			 }
  { guess what			 }
  { 0 = color, 1 = grayscale,	 }
  { >1 = FOURCC			 }
  { bitfield in fb mem if true color,  }
  { else only length is significant  }
  { transparency			 }  { != 0 Non standard pixel format  }
  { see FB_ACTIVATE_*		 }
  { height of picture in mm     }
  { width of picture in mm      }
  { (OBSOLETE) see fb_info.flags  }
  { Timing: All values in pixclocks, except pixclock (of course)  }
  { pixel clock in ps (pico seconds)  }
  { time from sync to picture	 }
  { time from picture to sync	 }
  { time from sync to picture	 }
  { length of horizontal sync	 }
  { length of vertical sync	 }
  { see FB_SYNC_*		 }
  { see FB_VMODE_*		 }
  { angle we rotate counter clockwise  }
  { colorspace for FOURCC-based modes  }
  { Reserved for future compatibility  }

  type
    fb_var_screeninfo = record
        xres : Uint32;
        yres : Uint32;
        xres_virtual : Uint32;
        yres_virtual : Uint32;
        xoffset : Uint32;
        yoffset : Uint32;
        bits_per_pixel : Uint32;
        grayscale : Uint32;
        red : fb_bitfield;
        green : fb_bitfield;
        blue : fb_bitfield;
        transp : fb_bitfield;
        nonstd : Uint32;
        activate : Uint32;
        height : Uint32;
        width : Uint32;
        accel_flags : Uint32;
        pixclock : Uint32;
        left_margin : Uint32;
        right_margin : Uint32;
        upper_margin : Uint32;
        lower_margin : Uint32;
        hsync_len : Uint32;
        vsync_len : Uint32;
        sync : Uint32;
        vmode : Uint32;
        rotate : Uint32;
        colorspace : Uint32;
        reserved : array[0..3] of Uint32;
      end;

  { First entry	 }
  { Number of entries  }
  { Red values	 }
  { transparency, can be NULL  }
    fb_cmap = record
        start : Uint32;
        len : Uint32;
        red : ^Uint16;
        green : ^Uint16;
        blue : ^Uint16;
        transp : ^Uint16;
      end;

    fb_con2fbmap = record
        console : Uint32;
        framebuffer : Uint32;
      end;

  { VESA Blanking Levels  }

  const
    VESA_NO_BLANKING = 0;    
    VESA_VSYNC_SUSPEND = 1;    
    VESA_HSYNC_SUSPEND = 2;    
    VESA_POWERDOWN = 3;    
(* error 
enum {
  { screen: unblanked, hsync: on,  vsync: on  }
  { screen: blanked,   hsync: on,  vsync: on  }
  { screen: blanked,   hsync: on,  vsync: off  }
  { screen: blanked,   hsync: off, vsync: on  }
  { screen: blanked,   hsync: off, vsync: off  }
in declaration at line 315 *)
    { currently in a vertical blank  }
      FB_VBLANK_VBLANKING = $001;      
    { currently in a horizontal blank  }
      FB_VBLANK_HBLANKING = $002;      
    { vertical blanks can be detected  }
      FB_VBLANK_HAVE_VBLANK = $004;      
    { horizontal blanks can be detected  }
      FB_VBLANK_HAVE_HBLANK = $008;      
    { global retrace counter is available  }
      FB_VBLANK_HAVE_COUNT = $010;      
    { the vcount field is valid  }
      FB_VBLANK_HAVE_VCOUNT = $020;      
    { the hcount field is valid  }
      FB_VBLANK_HAVE_HCOUNT = $040;      
    { currently in a vsync  }
      FB_VBLANK_VSYNCING = $080;      
    { verical syncs can be detected  }
      FB_VBLANK_HAVE_VSYNC = $100;      
    { FB_VBLANK flags  }
    { counter of retraces since boot  }
    { current scanline position  }
    { current scandot position  }
    { reserved for future compatibility  }

    type
      fb_vblank = record
          flags : Uint32;
          count : Uint32;
          vcount : Uint32;
          hcount : Uint32;
          reserved : array[0..3] of Uint32;
        end;

    { Internal HW accel  }

    const
      ROP_COPY = 0;      
      ROP_XOR = 1;      

    type
      fb_copyarea = record
          dx : Uint32;
          dy : Uint32;
          width : Uint32;
          height : Uint32;
          sx : Uint32;
          sy : Uint32;
        end;

    { screen-relative  }
      fb_fillrect = record
          dx : Uint32;
          dy : Uint32;
          width : Uint32;
          height : Uint32;
          color : Uint32;
          rop : Uint32;
        end;

    { Where to place image  }
    { Size of image  }
    { Only used when a mono bitmap  }
    { Depth of the image  }
(* Const before type ignored *)
    { Pointer to image data  }
    { color map info  }
      fb_image = record
          dx : Uint32;
          dy : Uint32;
          width : Uint32;
          height : Uint32;
          fg_color : Uint32;
          bg_color : Uint32;
          depth : Byte;
          data : ^char;
          cmap : fb_cmap;
        end;

    {
     * hardware cursor control
      }

    const
      FB_CUR_SETIMAGE = $01;      
      FB_CUR_SETPOS = $02;      
      FB_CUR_SETHOT = $04;      
      FB_CUR_SETCMAP = $08;      
      FB_CUR_SETSHAPE = $10;      
      FB_CUR_SETSIZE = $20;      
      FB_CUR_SETALL = $FF;      

    type
      fbcurpos = record
          x : Uint16;
          y : Uint16;
        end;

    { what to set  }
    { cursor on/off  }
    { bitop operation  }
(* Const before type ignored *)
    { cursor mask bits  }
    { cursor hot spot  }
    { Cursor image  }
      fb_cursor = record
          &set : Uint16;
          enable : Uint16;
          rop : Uint16;
          mask : ^char;
          hot : fbcurpos;
          image : fb_image;
        end;

{$ifdef CONFIG_FB_BACKLIGHT}
    { Settings for the generic backlight code  }

    const
      FB_BACKLIGHT_LEVELS = 128;      
      FB_BACKLIGHT_MAX = $FF;      
{$endif}
    { _LINUX_FB_H  }

implementation

    { was #define dname def_expr }
    function FBIO_WAITFORVSYNC : longint; { return type might be wrong }
      begin
      {$NOTE Macro needs to be resolved}
//        FBIO_WAITFORVSYNC:=_IOW('F',$20,Uint32);
      FBIO_WAITFORVSYNC := 0;
      end;

  { was #define dname(params) para_def_expr }
  { argument types are unknown }
  { return type might be wrong }   
  function PICOS2KHZ(a : longint) : longint;
  begin
    PICOS2KHZ:=1000000000 div a;
  end;

  { was #define dname(params) para_def_expr }
  { argument types are unknown }
  { return type might be wrong }   
  function KHZ2PICOS(a : longint) : longint;
  begin
    KHZ2PICOS:=1000000000 div a;
  end;


end.
