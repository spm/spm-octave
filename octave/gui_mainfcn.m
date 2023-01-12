########################################################################
##
## COMPATIBILITY FILE FOR GNU OCTAVE
##
## DELETE IF USING MATLAB OR IF USING A VERSION OF OCTAVE THAT ALREADY
## INCLUDES THIS FUNCTION
##
########################################################################
function varargout = gui_mainfcn (gui_state, varargin)

  if (nargin == 1 || isempty (gui_state.gui_Callback))
    ## Open figure
    copies = ifelse (gui_state.gui_Singleton, "reuse", "new");
    if (isempty (gui_state.gui_LayoutFcn))
      filename = file_in_loadpath ([gui_state.gui_Name ".fig"]);
      H = openfig (filename, copies, "invisible");
    else
      H = feval (gui_LayoutFcn, copies);
    endif

    ## Set figure properties from input
    for i = 1:2:numel (varargin)
      try
        set (H, varargin{i}, varargin{i+1});
      catch
        break;
      end_try_catch
    endfor

    ## Store graphics handles in guidata
    handles = guihandles (H);
    guidata (H, handles);

    ## Execute opening function
    feval (gui_state.gui_OpeningFcn, H, [], handles, varargin{:});
    set (H, "visible", "on");
    handles = guidata (H);

    ## Execute output function
    varargout{1} = feval (gui_state.gui_OutputFcn, H, [], handles);
  else
    [varargout{1:nargout}] = feval (gui_state.gui_Callback, varargin{2:end});
  endif

endfunction
