########################################################################
##
## COMPATIBILITY FILE FOR GNU OCTAVE
##
## DELETE IF USING MATLAB OR IF USING A VERSION OF OCTAVE THAT ALREADY
## INCLUDES THIS FUNCTION
##
########################################################################
function fun = fcnchk (fun, varargin)
if (ischar (fun))
    fun = str2func (fun);
elseif (isnumeric (fun))
    error ('Invalid input.');
endif
endfunction
