local baseFguiPanel = require("fgui.base.baseFguiPanel")
local VideoPlayerPanel = class("VideoPlayerPanel", baseFguiPanel)
function VideoPlayerPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("VideoPlayerPanel:ctor", self.viewName)
end
function VideoPlayerPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function VideoPlayerPanel:onInit()
	print("=======VideoPlayerPanel:onInit")
	self.paramData = self.param
	self.isUsmPlayer = true
	if self.paramData.usmUrl then
		self.videoFile = self.paramData.usmUrl
	else
		self.videoFile = self.paramData.videoFile
		self.videoFile = string.gsub(self.videoFile, ".mp4", ".usm", 1)
		local lastIdx = string.findlast(self.videoFile, "/")
		local strLength = string.len(self.videoFile)
		self.videoFile = string.sub(self.videoFile, lastIdx + 1, strLength)
		print(self.videoFile, "self.videoFile")
	end
	self.fields.click_panel:addEventListener(fgui.UIEventType.Click, handler(self, self.onPanelClick))
	self.fields.btn_skip:addClickEventListener(handler(self, self.onSkipClick))
	self.fields.Usm_1:setCompleteCallback(handler(self, self.onComplete))
	self.fields.Usm_1:setPrepareCallback(function(criSp)
		criSp:start()
		if self.videoViewSize then
			criSp:setScale(self.videoViewSize.width / criSp:getContentSize().width, self.videoViewSize.height / criSp:getContentSize().height)
		end
	end)
end
function VideoPlayerPanel:onShow()
	print("=======VideoPlayerPanel:onShow")
end
function VideoPlayerPanel:addSkipButton(title, isRA, url)
	self.isAdd = true
	self.fields.btn_skip:setVisible(true)
	local lastIdx = string.find(url, "res/")
	url = string.sub(url, lastIdx == 0 and 0 or lastIdx + 4, string.len(url))
	print("addSkipButton", url, lastIdx)
	fguiHelper.get_fields(self.fields.btn_skip).icon:setTexture(url)
	self.fields.btn_skip:setTitle(title)
end
function VideoPlayerPanel:removeSkipButton()
	self.isAdd = false
	self.fields.btn_skip:setVisible(false)
end
function VideoPlayerPanel:play()
	if self.paramData.pauseMusic then
		AudioEngine.pauseMusic()
	end
	self.fields.Usm_1:setEffectPath(self.videoFile, false)
end
function VideoPlayerPanel:onComplete()
	if self.paramData.pauseMusic then
		AudioEngine.resumeMusic()
	end
	if self.paramData.onCompleteFun then
		self.paramData.onCompleteFun(self)
	end
	self:close()
end
function VideoPlayerPanel:onSkipClick()
	if self.paramData.onSkipfunc then
		self.paramData.onSkipfunc(self)
	end
	self:onComplete()
end
function VideoPlayerPanel:onPanelClick()
	if self.paramData.onPanelClick then
		self.paramData.onPanelClick(self)
	end
end
function VideoPlayerPanel:setContentSize(size)
	self.videoViewSize = size
end
return VideoPlayerPanel
