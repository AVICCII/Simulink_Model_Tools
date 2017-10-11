%------------------------------------------------------------------------------
%   Simulink scrip for retype stateflow patameters 
%   MATLAB version: R2016a
%   Author: Shibo Jiang 
%   Version: 0.1
%   Instructions: 
%------------------------------------------------------------------------------
%   ����stateflow�б����������͵��ض���
%   MATLAB �汾: R2016a
%   ����: ������ 
%   �汾:    0.1
%   ˵��: 
%------------------------------------------------------------------------------

function fix_result = fix_stateflow_parameter_type()

paraModel = bdroot;

% Original matalb version is R2017a
% ���Matlab�汾�Ƿ�ΪR2017a
CorrectVersion = '9.2.0.556344 (R2017a)';
CurrentVersion = version;
if 1 ~= strcmp(CorrectVersion,CurrentVersion);
   warning('Matlab version mismatch, this scrip should be used for Matlab R2016a'); 
end

% Original environment character encoding: GBK
% �ű����뻷���Ƿ�ΪGBK
if ~strcmpi(get_param(0, 'CharacterEncoding'), 'GBK')
    warning('Simulink:EncodingUnMatched', 'The target character encoding (%s) is different from the original (%s).',...
           get_param(0, 'CharacterEncoding'), 'GBK');
end

% find all stateflow parameter
sf = sfroot;
all_sf_parameter = sf.find('-isa','Stateflow.Data');
j = 1;

if isempty(all_sf_parameter)
    % report the result
    fix_result = 'There is on stateflow parameter in this model.';
else
    % define the input/output parameter's data type
    length_sf_par = length(all_sf_parameter);
    for i = 1:length_sf_par
        % whether the paremeter is input/outport or others
        sf_par_scope = all_sf_parameter(i).Scope;
        switch sf_par_scope
        case 'Input'
            set(all_sf_parameter(i),'DataType','Inherit: Same as Simulink'); 
        case 'Output'  
            set(all_sf_parameter(i),'DataType','Inherit: Same as Simulink'); 
        otherwise
            other_sf_par(j) = all_sf_parameter(i);
            j = j + 1;
        end
    end
end

% define other stateflow parameters datatype
if isempty(other_sf_par)
    if isempty(fix_result)
        % report the result
        fix_result = 'Define stateflow parameters datatype successful';
    else
        % keep last fix_result
    end
else
    length_other_sf_par = length(other_sf_par);
    for i = 1:length_other_sf_par
        % get stateflow parameter's name
        sf_par_name = other_sf_par(i).Name;    
        try
            % get parameters datatype
            sf_par_datatype = sf_par_name(end-2:end);
            % translate the upper to lower
            sf_par_datatype = lower(sf_par_datatype);
            % calculate the data type config
            switch sf_par_datatype
            case '_u8'
                sf_par_datatype_cfg = 'uint8';
            case 'u16'
                sf_par_datatype_cfg = 'uint16';
            case 'u32'
                sf_par_datatype_cfg = 'uint32';
            case 'f32'
                sf_par_datatype_cfg = 'single';
            case 'f64'
                sf_par_datatype_cfg = 'double';
            case '_s8'
                sf_par_datatype_cfg = 'int8';
            case 's16'
                sf_par_datatype_cfg = 'int16';
            case 's32'
                sf_par_datatype_cfg = 'int32';
            case '_bl'
                sf_par_datatype_cfg = 'boolean';
            otherwise
                sf_par_datatype_cfg = 'uint8';
            end
            % define the stateflow parameter data type
            set(other_sf_par(i),'DataType',sf_par_datatype_cfg)
        catch
            
        end
    end
    fix_result = 'Define stateflow parameters datatype successful';
end