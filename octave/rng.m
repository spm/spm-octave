########################################################################
##
## COMPATIBILITY FILE FOR GNU OCTAVE
##
## DELETE IF USING MATLAB OR IF USING A VERSION OF OCTAVE THAT ALREADY
## INCLUDES THIS FUNCTION
##
########################################################################
function retval = rng (varargin)

  if (nargin > 2 || nargout > 1)
    print_usage ();
  endif

  ## Store current settings of random number generator
  ## FIXME: there doesn't seem to be a way to query the type of generator
  ##        currently used in Octave - assume "twister".
  ## FIXME: there doesn't seem to be a way to query the seed initialization
  ##        value - use "Not applicable".
  ## FIXME: rand and randn use different generators - storing both states.
  ## For older Matlab generators (v4, v5), the settings are stored like this:
  ##   struct ("Type","Legacy", "Seed", "Not applicable", "State",{[],[],...})
  s = struct (...
  "Type", "twister",...                        # generator name
  "Seed", "Not applicable",...                 # seed initialization value
  "State", {{rand("state"), randn("state")}}); # internal state of the generator

  if (! nargin)
    retval = s;
    return;
  endif

  if (isscalar (varargin{1}) && isnumeric (varargin{1}) && isreal (varargin{1}) && varargin{1} >= 0)
    s_rand = s_randn = varargin{1};
    generator = check_generator (varargin(2:end));

  elseif (ischar (varargin{1}) && strcmpi (varargin{1}, "shuffle"))
    ## Seed the random number generator based on the current time
    s_rand = s_randn = "reset"; # or sum (1000*clock)
    generator = check_generator (varargin(2:end));

  elseif (ischar (varargin{1}) && strcmpi (varargin{1}, "default") && nargin == 1)
    generator = "twister";
    s_rand = s_randn = 0; # In Matlab, seed 0 corresponds to 5489

  elseif (isstruct (varargin{1}) && isscalar (varargin{1}) && nargin == 1)
    if (numfields (varargin{1}) != 3 || ! isfield (varargin{1}, "Type")
      || ! isfield (varargin{1}, "Seed") || ! isfield (varargin{1}, "State"))
      error ("Input structure not compatible with the one returned by rng ()");
    endif
    ## Only the internal state "State" and generator type "Type" are needed
    generator = varargin{1}.Type;
    if (iscell (varargin{1}.State))
      [s_rand, s_randn] = deal (varargin{1}.State{:});
    else
      s_rand = s_randn = varargin{1}.State;
    endif

  else
    print_usage ();
  endif

  ## Set the type of random number generator and seed it
  if (isempty (generator))
    generator = s.Type;
  endif
  switch generator
    case "twister"
      rand ("state", s_rand);
      randn ("state", s_randn);

    case "legacy"
      rand ("seed", s_rand);
      randn ("seed", s_randn);

    case "v5uniform"
      rand ("seed", s_rand);

    case "v5normal"
      randn ("seed", s_randn);

  otherwise
    error ("Unknown type of random number generator");
    
  endswitch

  if (nargout > 0)
    retval = s;
  endif

endfunction


function gen = check_generator (val)
  if (isempty (val))
    gen = "";
    return;
  elseif (! iscellstr (val))
    error ("Second input must be a type of random number generator");
  endif
  gen = tolower (char (val));
  if (ismember (gen, {"simdtwister", "combrecursive", "philox", "threefry", "multfibonacci", "v4"}))
    error ("This random number generator is not available in Octave");
  elseif (! ismember (gen, {"twister", "v5uniform", "v5normal"}))
    error ("This type of random number generator is unknown");
  endif
endfunction
