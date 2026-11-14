require("app.scenes.MainScene")
local lang = userSDKManager.getChannel()
if lang == "ar" then
	require("app.svrconfig")
else
	require("app.svrconfig_en")
end
require("app.localtb.config_read.localReader")
