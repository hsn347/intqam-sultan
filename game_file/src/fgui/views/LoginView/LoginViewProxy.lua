local baseProxy = require("fgui.base.baseProxy")
local LoginViewProxy = class("LoginViewProxy", baseProxy)
function LoginViewProxy:onRegisterEvent()
	print("=======LoginViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_SUCCESS", handler(self, self.updateSucess))
	SoraDAddMessage(self, "MESSAGE_UPDATE_DOWNLOADPROGRESS", handler(self, self.onDownloadProgress))
	SoraDAddMessage(self, "MESSAGE_PRE_DOWNLOAD_LOGIN_PROGRESS", handler(self, self.onPreDownloadProgress))
	SoraDAddMessage(self, "MESSAGE_PRE_DOWNLOAD_LOGIN_PROGRESS_UNZIP", handler(self, self.onPreDownloadProgressUNZip))
	SoraDAddMessage(self, "MESSAGE_RECEIVE_OBB_MSG", handler(self, self.onReceiveObbMsg))
end
function LoginViewProxy:addIosAttGrantedFinEvent()
	SoraDAddMessage(self, "MESSAGE_IOS_ATT_GRANTED_FIN", handler(self.view, self.view.onAttGrantedComplete))
end
function LoginViewProxy:removeIosAttGrantedFinEvent()
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_IOS_ATT_GRANTED_FIN")
	self.view:startPatchUpdate()
end
function LoginViewProxy:updateSucess()
	if tolua.isnull(self.view) then
		return
	end
	self.view:updateSucess()
end
function LoginViewProxy:onDownloadProgress(target, data)
	self.view:onDownloadProgress(target, data)
end
function LoginViewProxy:onPreDownloadProgress(target, data)
	self.view:onPreDownloadProgress(target, data)
end
function LoginViewProxy:onPreDownloadProgressUNZip(target, data)
	self.view:onPreDownloadProgressUNZip(target, data)
end
function LoginViewProxy:onReceiveObbMsg(target, data)
	self.view:onReceiveObbMsg(target, data)
end
return LoginViewProxy
