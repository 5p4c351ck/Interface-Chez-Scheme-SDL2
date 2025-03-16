(library (sdl sdl2-basics)
(export	
	SDL_INIT_TIMER 		       
	SDL_INIT_AUDIO 		       
	SDL_INIT_VIDEO		       
	SDL_INIT_JOYSTICK	       
	SDL_INIT_HAPTIC		       
	SDL_INIT_GAMECONTROLLER        
	SDL_INIT_EVENTS		       
	SDL_INIT_EVERYTHING	       
	SDL_INIT_NOPARACHUTE	       
	SDL_WINDOW_FULLSCREEN 	       
	SDL_WINDOW_OPENGL	       
	SDL_WINDOW_SHOWN 	       
	SDL_WINDOW_HIDDEN	       
	SDL_WINDOW_BORDERLESS 	       
	SDL_WINDOW_RESIZABLE 	       
	SDL_WINDOW_MINIMIZED	       
	SDL_WINDOW_MAXIMIZED 	       
	SDL_WINDOW_INPUT_GRABBED       
	SDL_WINDOW_INPUT_FOCUS	       
	SDL_WINDOW_MOUSE_FOCUS	       
	SDL_WINDOW_FULLSCREEN_DESKTOP  
	SDL_WINDOW_FOREIGN	       	

 	SDL_WINDOWPOS_UNDEFINED_MASK 	       
 	SDL_WINDOWPOS_UNDEFINED_DISPLAY       
 	SDL_WINDOWPOS_UNDEFINED 	       
 	SDL_WINDOWPOS_ISUNDEFINED 	       
 	SDL_WINDOWPOS_CENTERED_MASK 	       
 	SDL_WINDOWPOS_CENTERED_DISPLAY        
 	SDL_WINDOWPOS_CENTERED		       
 	SDL_WINDOWPOS_ISCENTERED
	SDL_WINDOW_ALLOW_HIGHDPI

	SDL-WINDOW-MOUSE-CAPTURE       
	SDL-WINDOW-ALWAYS-ON-TOP       
	SDL-WINDOW-SKIP-TASKBAR        
	SDL-WINDOW-UTILITY             
	SDL-WINDOW-TOOLTIP             
	SDL-WINDOW-POPUP-MENU          
	SDL-WINDOW-KEYBOARD-GRABBED    
	SDL-WINDOW-VULKAN              
	SDL-WINDOW-METAL

	sdl-init		
	sdl-quit		
	sdl-create-window 	
	sdl-destroy-window	
	sdl-create-renderer	
	sdl-poll-event		
	sdl-get-window-surface 
	sdl-update-window-surface
	sdl-delay 
)
(import (chezscheme))

;;SDL/Init constants

(define SDL_INIT_TIMER 				#x00000001)
(define SDL_INIT_AUDIO 				#x00000010)
(define SDL_INIT_VIDEO 				#x00000020)
(define SDL_INIT_JOYSTICK 			#x00000200)
(define SDL_INIT_HAPTIC 			#x00001000)
(define SDL_INIT_GAMECONTROLLER 		#x00002000)
(define SDL_INIT_EVENTS 			#x00004000)
(define SDL_INIT_EVERYTHING 			#x0000FFFF)
(define SDL_INIT_NOPARACHUTE 			#x00100000)

;;SDL/Window constants

(define SDL_WINDOW_FULLSCREEN 			#x00000001)
(define SDL_WINDOW_OPENGL 			#x00000002)
(define SDL_WINDOW_SHOWN 			#x00000004)
(define SDL_WINDOW_HIDDEN 			#x00000008)
(define SDL_WINDOW_BORDERLESS 			#x00000010)
(define SDL_WINDOW_RESIZABLE 			#x00000020)
(define SDL_WINDOW_MINIMIZED			#x00000040)
(define SDL_WINDOW_MAXIMIZED 			#x00000080)
(define SDL_WINDOW_INPUT_GRABBED 		#x00000100)
(define SDL_WINDOW_INPUT_FOCUS 			#x00000200)
(define SDL_WINDOW_MOUSE_FOCUS 			#x00000400)
(define SDL_WINDOW_FULLSCREEN_DESKTOP 		(logior SDL_WINDOW_FULLSCREEN  #x00001000))
(define SDL_WINDOW_FOREIGN 			#x00000800)
(define SDL_WINDOW_ALLOW_HIGHDPI 		#x00002000)

(define SDL-WINDOW-MOUSE-CAPTURE    		#x00004000)  
(define SDL-WINDOW-ALWAYS-ON-TOP    		#x00008000)  
(define SDL-WINDOW-SKIP-TASKBAR     		#x00010000)  
(define SDL-WINDOW-UTILITY          		#x00020000)  
(define SDL-WINDOW-TOOLTIP          		#x00040000)  
(define SDL-WINDOW-POPUP-MENU       		#x00080000)  
(define SDL-WINDOW-KEYBOARD-GRABBED 		#x00100000)  
(define SDL-WINDOW-VULKAN           		#x10000000)  
(define SDL-WINDOW-METAL            		#x20000000)  

(define SDL_WINDOWPOS_UNDEFINED_MASK 		#x1FFF0000)
(define (SDL_WINDOWPOS_UNDEFINED_DISPLAY x) 	(logior SDL_WINDOWPOS_UNDEFINED_MASK x))
(define SDL_WINDOWPOS_UNDEFINED 	    	(SDL_WINDOWPOS_UNDEFINED_DISPLAY 0))
(define (SDL_WINDOWPOS_ISUNDEFINED x)		(= (logand x #xFFFF0000) SDL_WINDOWPOS_UNDEFINED_MASK))

(define SDL_WINDOWPOS_CENTERED_MASK 		#x2FFF0000)
(define (SDL_WINDOWPOS_CENTERED_DISPLAY x)  	(logior SDL_WINDOWPOS_CENTERED_MASK x))
(define SDL_WINDOWPOS_CENTERED		 	(SDL_WINDOWPOS_CENTERED_DISPLAY 0))
(define (SDL_WINDOWPOS_ISCENTERED x)		(= (logand x #xFFFF0000) SDL_WINDOWPOS_CENTERED_MASK))

;;Macro wrapper with error checking for foreign-procedure

(define-syntax sdl-procedure
    (syntax-rules ()
      ((sdl-procedure name params return)
       (if (foreign-entry? name)
	   (foreign-procedure name params return)
	   (lambda args
	     (error 'libSDL2.so "Function not exported in libSDL2.so" name))))))

;;Load the SDL2 shared object

(define sdl (load-shared-object "/usr/lib/x86_64-linux-gnu/libSDL2.so"))

;;Definitions for the C bindings of the libSDL2 subroutines

(define sdl-init		(sdl-procedure "SDL_Init" 			(unsigned-32) int))
(define sdl-quit		(sdl-procedure "SDL_Quit" 			() void))
(define sdl-create-window 	(sdl-procedure "SDL_CreateWindow" 		(string int int int int unsigned-32) ptr))
(define sdl-destroy-window	(sdl-procedure "SDL_DestroyWindow" 		(ptr) void))
(define sdl-create-renderer	(sdl-procedure "SDL_CreateRenderer" 		(ptr int unsigned-32) ptr))
(define sdl-poll-event		(sdl-procedure "SDL_PollEvent" 			(ptr) int))
(define sdl-get-window-surface  (sdl-procedure "SDL_GetWindowSurface" 		(ptr) ptr))
(define sdl-update-window-surface (sdl-procedure "SDL_UpdateWindowSurface" 	(ptr) int))
(define sdl-delay  (sdl-procedure "SDL_Delay" (unsigned-32) void))

)
