function [tfr,t,f] = tfrri(x,t,N,trace);
%TFRRI	Rihaczek time-frequency distribution.
%	[TFR,T,F]=TFRRI(X,T,N,TRACE) computes the Rihaczek distribution
%	of a discrete-time signal X, 
%	or the cross Rihaczek representation between two signals. 
% 
%	X     : signal if auto-Ri, or [X1,X2] if cross-Ri.
%	T     : time instant(s)           (default : 1:length(X)).
%	N     : number of frequency bins  (default : length(X)).
%	TRACE : if nonzero, the progression of the algorithm is shown
%	                                  (default : 0).
%	TFR   : time-frequency representation. When called without 
%	       output arguments, TFRRI applies TFRQVIEW on the real
%	       part of the distribution, which is equal to the
%	       Margenau-Hill distribution.
%	F     : vector of normalized frequencies.
%
%	Example :
%	 sig=fmlin(128,0.1,0.4); tfrri(sig);
% 
%	See also all the time-frequency representations listed in
%	 the file CONTENTS (TFR*)

%	F. Auger, May-August 1994, July 1995.
%	Copyright (c) 1996 by CNRS (France).
%
%	------------------- CONFIDENTIAL PROGRAM -------------------- 
%	This program can not be used without the authorization of its
%	author(s). For any comment or bug report, please send e-mail to 
%	f.auger@ieee.org

if (nargin == 0),
 error('At least 1 parameter required');
end;

[xrow,xcol] = size(x);
if (nargin == 1),
 t=1:xrow; N=xrow; trace=0;
elseif (nargin == 2),
 N=xrow; trace=0;
elseif (nargin == 3),
 trace = 0;
end;

if (N<0),
 error('N must be greater than zero');
end;
[trow,tcol] = size(t);
if (xcol==0) | (xcol>2),
 error('X must have one or two columns');
elseif (trow~=1),
 error('T must only have one row'); 
elseif (2^nextpow2(N)~=N & nargin==4),
 fprintf('For a faster computation, N should be a power of two\n');
end; 

tfr= zeros (N,tcol) ;  
if trace, disp('Rihaczek distribution'); end;
for icol=1:tcol,
 ti= t(icol); tau=-min([N-ti,xrow-ti]):(ti-1);
 indices= rem(N+tau,N)+1; 
 if trace, disprog(icol,tcol,10); end;
 tfr(indices,icol)=x(ti,1)*conj(x(ti-tau,xcol));
end; 
if trace, fprintf('\n'); end;
tfr= fft(tfr); 

if (nargout==0),
 fprintf('if your goal is a graphical output, you should rather use tfrmh.\n');
 tfrqview(real(tfr),x,t,'tfrmh');
elseif (nargout==3),
 f=fftshift((-N/2:N/2-1)/N)';
end;
