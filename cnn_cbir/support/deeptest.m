function val = deeptest(net,t,y,ew)

if nargin < 3, error(message('nnet:Args:NotEnough')); end
[net,err] = nntype.network('format',net);
if ~isempty(err),nnerr.throw(nnerr.value(err,'NET')); end
if isempty(net.performFcn),
  error(message('nnet:NNet:PerformFcnUndefined'));
end
if nargin < 4, ew = {1}; end

if ~iscell(t), t = {t}; end
if ~iscell(y), y = {y}; end
if ~iscell(ew), ew = {ew}; end
val = ((nncalc.perform(net,t,y,ew,net.performParam)));


