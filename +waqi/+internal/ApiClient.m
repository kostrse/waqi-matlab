classdef ApiClient
    properties (Access = private)
        endpoint string
        token string
    end

    methods
        function obj = ApiClient(endpoint, token)
            obj.endpoint = endpoint;
            obj.token = token;
        end

        function result = get(obj, path, query)
            url = matlab.net.URI(obj.endpoint);
            url.Path = path;
            url.Query = [matlab.net.QueryParameter(query), matlab.net.QueryParameter("token", obj.token)];

            req = matlab.net.http.RequestMessage(matlab.net.http.RequestMethod.GET);

            options = matlab.net.http.HTTPOptions(MaxRedirects=0);
            resp = send(req, url.EncodedURI, options);

            if resp.StatusCode ~= matlab.net.http.StatusCode.OK
                error("WAQI request failed with status code '" + resp.StatusCode + "'.");
            end

            respBody = resp.Body.Data;

            if ~isfield(respBody, "status")
                error("WAQI request returned invalid response.");
            end

            if respBody.status ~= "ok"
                if ~isfield(respBody, "message")
                    error("WAQI request failed with status '" + respBody.status + "'.");
                else
                    error("WAQI request failed with error: " + respBody.message + ".");
                end
            end

            if ~isfield(respBody, "data")
                error("WAQI request did not return any data.");
            else
                result = respBody.data;
            end
        end
    end
end
