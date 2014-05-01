!INCLUDE <$(WCECOMPAT)\wcedefs.mak>

CFLAGS=/MT /W3 /Ox /O2 /Ob2 /GF /Gy /Zl /nologo $(WCETARGETDEFS) \
	   /DUNICODE /D_UNICODE /DWIN32 /D_USE_32BIT_TIME_T \
	   /DWIN32_LEAN_AND_MEAN /D_WINDLL /D_DLL /Foobj/ \
	   -I$(WCECOMPAT)/include \
	   -Isrc -I..\luace\src \
	   -DNO_SYS_TYPES_H \
	   -D_CRT_SECURE_NO_DEPRECATE \
	   -D_CRT_SECURE_NO_WARNINGS \
	   "-DLUASOCKET_API=__declspec(dllexport)" \
	   "-DMIME_API=__declspec(dllexport)" 


!IF "$(WCEPLATFORM)"=="MS_POCKET_PC_2000"
CFLAGS=$(CFLAGS) /DWIN32_PLATFORM_PSPC
!ENDIF

!IFDEF DEBUG
CFLAGS=$(CFLAGS) /Zi /DDEBUG /D_DEBUG
!ELSE
CFLAGS=$(CFLAGS) /Zi /DNDEBUG
!ENDIF

!IF "$(MSVS)"=="2008"
CFLAGS=$(CFLAGS) /Zc:wchar_t-,forScope- /GS-
LFLAGS=/DLL /MACHINE:$(WCELDMACHINE) /SUBSYSTEM:WINDOWSCE,$(WCELDVERSION) /NODEFAULTLIB /DYNAMICBASE /NXCOMPAT
!ELSE
LFLAGS=/DLL /MACHINE:$(WCELDMACHINE) /SUBSYSTEM:WINDOWSCE,$(WCELDVERSION) /NODEFAULTLIB
!ENDIF

CORELIBS=coredll.lib corelibc.lib ole32.lib oleaut32.lib uuid.lib commctrl.lib ws2.lib \
		     ../wcecompat/lib/wcecompat.lib \
		     ../luace/lib/lua51.lib

SRC = \
 src/luasocket.c \
 src/timeout.c \
 src/buffer.c \
 src/io.c \
 src/auxiliar.c \
 src/options.c \
 src/inet.c \
 src/wsocket.c \
 src/except.c \
 src/select.c \
 src/tcp.c \
 src/udp.c 

MIME_SRC = \
 src/mime.c 

OBJS = $(SRC:src=obj)
OBJS = $(OBJS:.cpp=.obj)
OBJS = $(OBJS:.c=.obj)

MIME_OBJS = $(MIME_SRC:src=obj)
MIME_OBJS = $(MIME_OBJS:.cpp=.obj)
MIME_OBJS = $(MIME_OBJS:.c=.obj)

{src}.c{obj}.obj:
	$(CC) $(CFLAGS) -c $<

all: lib lib\socket.lib lib\mime.lib
#	echo $(OBJS)

obj:
	@md obj 2> NUL

lib:
	@md lib 2> NUL

$(OBJS): ce.mak obj

$(MIME_OBJS): ce.mak obj

clean:
	@echo Deleting target libraries...
	@del lib\*.lib
	@echo Deleting object files...
	@del obj\*.obj

lib\socket.lib: lib $(OBJS) makefile
	link /nologo /out:lib/socket.dll $(LFLAGS) $(OBJS) $(CORELIBS)

lib\mime.lib: lib $(OBJS) makefile
	link /nologo /out:lib/mime.dll $(LFLAGS) $(OBJS) $(CORELIBS)


