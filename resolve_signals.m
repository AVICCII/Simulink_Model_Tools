%------------------------------------------------------------------------------
%   Simulink scrip for resolve to signals.
%   MATLAB version: R2016a
%   Author: Shibo Jiang 
%   Version: 0.1
%   Instructions: 
%------------------------------------------------------------------------------
%   用于在信号线上勾选 Signal name must resolve to Simulink signal object 的脚本
%   MATLAB 版本: R2016a
%   作者: 姜世博 
%   版本:    0.1
%   说明: 
%------------------------------------------------------------------------------

function resolve_signals_result = resolve_signals()

paraModel = bdroot;

% Original matalb version is R2016a
% 检查Matlab版本是否为R2016a
CorrectVersion = '9.0.0.341360 (R2016a)';
CurrentVersion = version;
if 1 ~= strcmp(CorrectVersion,CurrentVersion);
   %warning('Matlab version mismatch, this scrip should be used for Matlab R2016a'); 
end

% Original environment character encoding: GBK
% 脚本编码环境是否为GBK
if ~strcmpi(get_param(0, 'CharacterEncoding'), 'GBK')
    warning('Simulink:EncodingUnMatched', 'The target character encoding (%s) is different from the original (%s).',...
           get_param(0, 'CharacterEncoding'), 'GBK');
end

all_line = find_system(paraModel,'FindAll','on','type','line');
% Parameters define
k = 1;
enable_rs_flag = 0;
length_line = length(all_line);

% Find the line which need propagating signals
for i = 1:length_line
    % Detect 'Signal name'
    current_line_name = get(all_line(i),'Name');
    % Detect 'Signal name must resolve to Simulink signal object' state
    current_line_rs = get(all_line(i),'MustResolveToSignalObject');

    % judge whether signal has name 
    if 1 == isempty(current_line_name)
        % no name
        ne_flag = 1;
    else
        % have name
        ne_flag = 0;
    end
    % judge whether signal set must resolve to signal object
    if 0 == current_line_rs
        rs_flag = 4;
    else
        rs_flag = 0;
    end
    % Mark the line which both resolve to signal and Name are disabled
    line_b_flag = bitor(rs_flag,ne_flag);
    if  4 == line_b_flag
        resolve_singals_line(k) = all_line(i);
        k = k + 1;
        enable_rs_flag = 1;
    else
        % Do nothing
    end
end

% set 'Signal name must resolve to Simulink signal object' to on
if 1 == enable_rs_flag
    length_rs_line = length(resolve_singals_line);
    for i = 1:length_rs_line
        try
            set(resolve_singals_line(i),'MustResolveToSignalObject',1);
        catch
            % do nothing
        end
    end
    % report configurate results
    resolve_signals_result = 'resolve signals successful';
else
    % report configurate results
    resolve_signals_result = 'No signal line need resovling to signal';
end