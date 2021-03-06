classdef HowiePositioningSystem < handle
    %HowiePositioningSystem Locates Howie!
    
    properties (SetAccess = immutable)
        url = 'http://beorn.rel.ri.cmu.edu:16311'
    end
    
    properties (Access = private)
        data = struct()
    end
    
    methods
        function s = HowiePositioningSystem(url)
            if nargin == 1
                s.url = url;
            end
        end
        
        function ids = getVisibleIds(self)
            %getVisibleIds Returns a vector of detected tag ids
            self.fetch;
            ids = cellfun(@(s) str2double(s(3:end)), fieldnames(self.data));
        end

        function pos = getPosition(self, id)
            %getPosition Returns the position of a tag
            % Return value is a struct with x, y, and th fields
            self.fetch;
            try
                pos = self.data.(['id' num2str(id)]);
            catch ME
                if strcmp(ME.identifier, 'MATLAB:nonExistentField')
                    ME = MException('HowiePositioningSystem:getPosition', ...
                          sprintf('Tag with id %d is not visible', id));
                    ME.throw;
                else
                    rethrow(ME);
                end
            end                
        end
    end
    
    methods (Access = protected)
        function fetch(self)
            response = urlread(self.url);
            response = parse_json(response);
            response = response{1};
            
            self.data = struct();
            if ~isempty(response)
                names = fieldnames(response);

                for i = 1:length(names)
                    vals = response.(names{i});
                    self.data.(names{i}) = struct('x', vals{1}, 'y', vals{2}, 'th', vals{3});
                end
            end
        end
    end
end


%{
Copyright (c) 2008, The MathWorks, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution
    * Neither the name of the The MathWorks, Inc. nor the names
      of its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
%}

function [data json] = parse_json(json)
% [DATA JSON] = PARSE_JSON(json)
% This function parses a JSON string and returns a cell array with the
% parsed data. JSON objects are converted to structures and JSON arrays are
% converted to cell arrays.
%
% Example:
% google_search = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=matlab';
% matlab_results = parse_json(urlread(google_search));
% disp(matlab_results{1}.responseData.results{1}.titleNoFormatting)
% disp(matlab_results{1}.responseData.results{1}.visibleUrl)

    data = cell(0,1);

    while ~isempty(json)
        [value json] = parse_value(json);
        data{end+1} = value; %#ok<AGROW>
    end
end

function [value json] = parse_value(json)
    value = [];
    if ~isempty(json)
        id = json(1);
        json(1) = [];
        
        json = strtrim(json);
        
        switch lower(id)
            case '"'
                [value json] = parse_string(json);
                
            case '{'
                [value json] = parse_object(json);
                
            case '['
                [value json] = parse_array(json);
                
            case 't'
                value = true;
                if (length(json) >= 3)
                    json(1:3) = [];
                else
                    ME = MException('json:parse_value',['Invalid TRUE identifier: ' id json]);
                    ME.throw;
                end
                
            case 'f'
                value = false;
                if (length(json) >= 4)
                    json(1:4) = [];
                else
                    ME = MException('json:parse_value',['Invalid FALSE identifier: ' id json]);
                    ME.throw;
                end
                
            case 'n'
                value = [];
                if (length(json) >= 3)
                    json(1:3) = [];
                else
                    ME = MException('json:parse_value',['Invalid NULL identifier: ' id json]);
                    ME.throw;
                end
                
            otherwise
                [value json] = parse_number([id json]); % Need to put the id back on the string
        end
    end
end

function [data json] = parse_array(json)
    data = cell(0,1);
    while ~isempty(json)
        if strcmp(json(1),']') % Check if the array is closed
            json(1) = [];
            return
        end
        
        [value json] = parse_value(json);
        
        if isempty(value)
            ME = MException('json:parse_array',['Parsed an empty value: ' json]);
            ME.throw;
        end
        data{end+1} = value; %#ok<AGROW>
        
        while ~isempty(json) && ~isempty(regexp(json(1),'[\s,]','once'))
            json(1) = [];
        end
    end
end

function [data json] = parse_object(json)
    data = [];
    while ~isempty(json)
        id = json(1);
        json(1) = [];
        
        switch id
            case '"' % Start a name/value pair
                [name value remaining_json] = parse_name_value(json);
                if isempty(name)
                    ME = MException('json:parse_object',['Can not have an empty name: ' json]);
                    ME.throw;
                end
                data.(name) = value;
                json = remaining_json;
                
            case '}' % End of object, so exit the function
                return
                
            otherwise % Ignore other characters
        end
    end
end

function [name value json] = parse_name_value(json)
    name = [];
    value = [];
    if ~isempty(json)
        [name json] = parse_string(json);
        
        % Skip spaces and the : separator
        while ~isempty(json) && ~isempty(regexp(json(1),'[\s:]','once'))
            json(1) = [];
        end
        [value json] = parse_value(json);
    end
end

function [string json] = parse_string(json)
    string = [];
    while ~isempty(json)
        letter = json(1);
        json(1) = [];
        
        switch lower(letter)
            case '\' % Deal with escaped characters
                if ~isempty(json)
                    code = json(1);
                    json(1) = [];
                    switch lower(code)
                        case '"'
                            new_char = '"';
                        case '\'
                            new_char = '\';
                        case '/'
                            new_char = '/';
                        case {'b' 'f' 'n' 'r' 't'}
                            new_char = sprintf('\%c',code);
                        case 'u'
                            if length(json) >= 4
                                new_char = sprintf('\\u%s',json(1:4));
                                json(1:4) = [];
                            end
                        otherwise
                            new_char = [];
                    end
                end
                
            case '"' % Done with the string
                return
                
            otherwise
                new_char = letter;
        end
        % Append the new character
        string = [string new_char]; %#ok<AGROW>
    end
end

function [num json] = parse_number(json)
    num = [];
	if ~isempty(json)
        % Validate the floating point number using a regular expression
        [s e] = regexp(json,'^[\w]?[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?[\w]?','once');
        if ~isempty(s)
            num_str = json(s:e);
            json(s:e) = [];
            num = str2double(strtrim(num_str));
        end
    end
end

    

