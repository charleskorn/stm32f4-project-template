file(GLOB children *)

foreach(child ${children})
    if(IS_DIRECTORY ${child})
      add_subdirectory(${child})
    endif()
endforeach()
