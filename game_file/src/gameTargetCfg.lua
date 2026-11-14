local CSUserSDKManager = CS.Sultan.Manager.UserSDKManager.GetInstance()
local channel = CSUserSDKManager:getChannel()
gGameDefaultChannel = channel or "en"
gIsGameService = false
