local MainSceneMoive = class("MainSceneMoive", function()
	return display.newScene("MainSceneMoive")
end)
_ENV, _UPVALUE5_ = function()
	return display.newScene("MainSceneMoive")
end, "MainSceneMoive"
_ENV, (function()
	return display.newScene("MainSceneMoive")
end).name = nil, "logo5_3.mov"
_ENV, (nil).name = nil, "logo5_3.mov"
_ENV, (nil).name = nil, "logo5_3.mov"
_ENV, (nil).name = nil, "logo5_3.mov"
;(nil).name = "logo5_3.mov"
;("MainSceneMoive")[1] = function()
	return display.newScene("MainSceneMoive")
end
;("MainSceneMoive")[2] = nil
;("MainSceneMoive")[3] = nil
;("MainSceneMoive")[4] = nil
local ("MainSceneMoive")[5], res_data = nil, "MainSceneMoive"
function MainSceneMoive:ctor()
	_ENV = nil
	;(nil).UILabelType = 2
	;(nil).text = "Hello, World"
	;(nil).size = 64
	cc.ui.UILabel.new(nil):align(display.CENTER, display.cx, display.cy):addTo(self)
	self.dropBox_svr = include("commonDropBox").new()
	_ENV = self
	self.width = 200
	self.singleWidth = 150
	self.dropBox_svr:initConfig(self)
	self.dropBox_svr:initData(res_data)
	self.dropBox_svr:initView()
	self.dropBox_svr:setPosition(cc.p(440, display.height - 0))
	self.dropBox_svr:addTo(self, 100)
	self.dropBox_svr:setHandleChoose(function(target, index, data)
		local svrInfo = self.dropBox_svr:getSelectedItem()
		self:play(svrInfo)
	end)
	self.dropBox_svr:initDefaultIndex(1)
end
function MainSceneMoive:play(data)
	dump(data, "data", 10)
	if self.video then
		self.video:removeFromParent()
		self.video = nil
	end
	if device.platform == "mac" then
		print("请在iOS或Android上观赏视频")
		return
	end
	local video = ccexp.VideoPlayer:create()
	video:setPosition(cc.p(display.cx, display.cy))
	video:setAnchorPoint(cc.p(0.5, 0.5))
	video:setContentSize(cc.size(display.width, display.height))
	video:setFileName("video/" .. data.name)
	video:setKeepAspectRatioEnabled(true)
	video:setFullScreenEnabled(true)
	self:addChild(video)
	local onVideoEventCallback = function(sender, eventType)
		print("onVideoEventCallback:", eventType)
		if eventType == ccexp.VideoPlayerEvent.PLAYING then
		elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
		elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
		elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
			self.video:setFullScreenEnabled(false)
			self.video:setVisible(false)
		end
	end
	video:addEventListener(onVideoEventCallback)
	video:play()
	self.video = video
end
function MainSceneMoive:onEnter()
end
function MainSceneMoive:onExit()
end
return MainSceneMoive
