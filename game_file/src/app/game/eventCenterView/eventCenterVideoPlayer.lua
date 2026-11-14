local eventCenterVideoPlayer = class("eventCenterVideoPlayer")
function eventCenterVideoPlayer:create(parent)
	self.parent = parent
	self.pageView = parent.pageView
	_ENV = nil
	;(nil).byUID = true
	self.hasAutoPlay = SoraDConfigGet("Game:eventCenterVideoPlayer:hasAutoPlay~bool", nil)
	return self
end
function eventCenterVideoPlayer:createVideoPlayer(csbNode)
	local videoPlayer = csbNode:getChildByName("videoPlayer")
	if videoPlayer then
		return
	end
	_ENV = csbNode
	csbNode.videoFile = "video/movie2.3gp"
	function csbNode.onCompleteFun(_video)
		print("==onCompleteFun==")
		if not _video or G_IS_UNITY then
			return
		end
		if device.platform == "android" then
			_video:setVisible(false)
			_video:setVisible(true)
			SoraDCallOnNextFrame(_video, function()
				_video:seekTo(0)
				_video:pause()
			end, 0.3)
		elseif device.platform == "ios" then
			SoraDCallOnNextFrame(_video, function()
				_video:seekTo(0)
			end)
		end
	end
	function csbNode.onPanelClick(_video)
		print("==onPanelClick==")
		SoraDPlaySound()
		if _video then
			if _video.state == ccexp.VideoPlayerEvent.STOPPED then
				_video:play()
			elseif _video.state == ccexp.VideoPlayerEvent.PAUSED then
				_video:resume()
			elseif _video.state == ccexp.VideoPlayerEvent.COMPLETED then
				_video:play()
			elseif _video.state == ccexp.VideoPlayerEvent.PLAYING then
				_video:pause()
			else
				_video:play()
			end
		end
	end
	function csbNode.onStopfunc(_video)
		print("==onStopfunc==")
	end
	csbNode.parent = csbNode
	local csbNode.needRemove, data = false, csbNode
	local videoPlayer = SoraDCreateVideoPlayerSingle(data)
	if videoPlayer then
		videoPlayer:setPosition(cc.p(display.cx, 155))
		videoPlayer:setContentSize(cc.size(display.width, 300))
		videoPlayer:setKeepAspectRatioEnabled(false)
		videoPlayer:setFullScreenEnabled(false)
		local panel = videoPlayer:getParent():getChildByName("touchPanel")
		if panel then
			panel:setContentSize(cc.size(display.width, 305))
			panel:setSwallowTouches(false)
		end
		self.isVideoPlayerInit = true
		if self.isLeavePanel then
			videoPlayer:setVisible(false)
		end
	end
end
function eventCenterVideoPlayer:createVideoPlayerBig()
	local csbNode = display.getRunningScene()
	local videoPlayer = self:getBigVideoPlaying()
	if videoPlayer then
		return
	end
	_ENV = self
	self.videoFile = "video/anniversaryMovie.mp4"
	function self.onCompleteFun(_video)
		print("==onCompleteFun==")
	end
	function self.onPanelClick(_video)
		print("==onPanelClick==")
		if not _video.isAddBtn then
			SoraDPlaySound()
			_video:addSkipButton(" ", SoraDFIsRA(), "res/video/closeBtn.png", true)
			SoraDCallOnNextFrame(_video, function()
				_video:removeSkipButton()
			end, 2.0)
		else
			_video:stopAllActions()
			SoraDCallOnNextFrame(_video, function()
				_video:removeSkipButton()
			end, 2.0)
		end
		if _video and _video.isVideoPause then
			_video:resume()
		end
	end
	function self.onStopfunc(_video)
		print("==onStopfunc==")
	end
	local self.parent, data = csbNode, self
	local videoPlayer = SoraDCreateVideoPlayerSingle(data)
	if videoPlayer then
		videoPlayer:play()
	end
end
function eventCenterVideoPlayer:onIntoPanel(...)
	print("==eventCenterVideoPlayer:onIntoPanel==")
	self.isLeavePanel = false
	if not self.isVideoPlayerInit then
		return
	end
	local videoPlayer = self:getVideoPlayer()
	if videoPlayer then
		videoPlayer:setVisible(true)
		if G_IS_UNITY then
			return
		end
		if device.platform == "android" then
			SoraDCallOnNextFrame(videoPlayer, function()
				videoPlayer:seekTo(0)
				videoPlayer:pause()
			end, 0.3)
		elseif device.platform == "ios" then
			videoPlayer:pause()
		end
	end
end
function eventCenterVideoPlayer:onLeavePanel(...)
	print("==eventCenterVideoPlayer:onLeavePanel==")
	self.isLeavePanel = true
	if not self.isVideoPlayerInit then
		return
	end
	local videoPlayer = self:getVideoPlayer()
	if videoPlayer then
		videoPlayer:setVisible(false)
		videoPlayer:pause()
	end
end
function eventCenterVideoPlayer:checkVideoPlayerState(...)
	if not self.isVideoPlayerInit then
		return
	end
	local curPageIndex = self.pageView:getCurPageIndex()
	self.prePageIndex = self.prePageIndex or curPageIndex
	if self.prePageIndex == curPageIndex then
		return
	end
	self.prePageIndex = curPageIndex
	local videoPlayer = self:getCurPageVideoPlayer()
	if videoPlayer and videoPlayer:isVisible() then
		if self.hasAutoPlay then
			videoPlayer:pause()
		else
			self.hasAutoPlay = true
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:eventCenterVideoPlayer:hasAutoPlay~bool", true, nil)
			videoPlayer:play()
		end
	else
		videoPlayer = self:getVideoPlayer()
		if videoPlayer and videoPlayer.state == ccexp.VideoPlayerEvent.PLAYING then
			videoPlayer:pause()
		end
	end
end
function eventCenterVideoPlayer:getCurPageVideoPlayer(...)
	if not self.isVideoPlayerInit then
		return
	end
	local page = self.pageView:getPage(self.pageView:getCurPageIndex())
	if not page then
		return
	end
	local node = page:getChildByName("Node_father")
	if not node then
		return
	end
	local videoPlayer = SoraDGetChildByName(node, "videoPlayer")
	if videoPlayer then
		return videoPlayer
	end
end
function eventCenterVideoPlayer:getVideoPlayer(...)
	if not self.isVideoPlayerInit then
		return
	end
	return SoraDGetChildByName(self.parent.pageView, "videoPlayer")
end
function eventCenterVideoPlayer:isVideoPlaying(...)
	if not self.isVideoPlayerInit then
		return
	end
	local videoPlayer = self:getCurPageVideoPlayer()
	return videoPlayer and videoPlayer.state == ccexp.VideoPlayerEvent.PLAYING
end
function eventCenterVideoPlayer:getBigVideoPlaying(...)
	local csbNode = display.getRunningScene()
	local videoNode = csbNode:getChildByName("videoNode")
	if videoNode then
		return videoNode:getChildByName("videoPlayer")
	end
end
function eventCenterVideoPlayer:checkMusic(...)
	if not self.isVideoPlayerInit then
		return
	end
	if self:isVideoPlaying() or self:getBigVideoPlaying() then
		AudioEngine.pauseMusic()
	elseif self.isVideoPlayerInit then
		AudioEngine.resumeMusic()
	end
end
function eventCenterVideoPlayer:onExitPanel(...)
	if self.isVideoPlayerInit then
		AudioEngine.resumeMusic()
	end
end
return eventCenterVideoPlayer
