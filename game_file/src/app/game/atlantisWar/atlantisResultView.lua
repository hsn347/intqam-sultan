local lordLocalData = include("lordLocalData")
local ATC = require_data("atlantiswar_title_config").data
local atlantisResultView = class("atlantisResultView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisResultView")
	end
	return target
end)
function atlantisResultView:ctor()
	self.enableTouchCloseSelf = true
	self:initWidget()
end
function atlantisResultView:test(...)
	_ENV, _ENV = nil, nil
	;(nil).kid = 1
	;(nil).name = "playerName"
	;(nil).occupyScore = 7777777
	;(nil).personalData, _ENV, (nil).titles, _ENV, (nil).topScorePlayer, (nil).headid = nil, nil, nil, nil, nil, 1401
	local data
	local _ENV, titles
	for i = 1, 4 do
		_ENV = nil
		;(nil).kid = 1
		;(nil).name = "playerName"
		;(nil).score = 7777
		;(nil).headid = 1402
		table.insert(titles, nil)
	end
	data.titles = titles
	self:initData(data)
end
function atlantisResultView:initWidget(...)
	local et_view = SoraDCreatAnimationEx(self.__cname, self._ccsView, false)
	local startIndex, endIndex
	et_view.action:setFrameEventCallFunc(function(frameEventName)
		local frameEvent = frameEventName:getEvent()
		print("====frameEvent====", frameEvent, frameEventName:getFrameIndex())
		if frameEvent == "loopEnd" and not endIndex then
			et_view.action:clearFrameEventCallFunc()
			et_view.action:gotoFrameAndPlay(startIndex, endIndex, true)
		end
	end)
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	SoraDGetAllChildFromWidget(self.Center_Node, self)
	self.Button_close:addTouchEventListener(handler(self, self.close))
	_UPVALUE2_ = handler(self, self.close)
	handler(self, self.close)[1] = "ar"
	handler(self, self.close)[2] = "en"
	local icon = SoraDGetImageNameByLang("frame_shmc_mvp_%s.png", handler(self, self.close))
	self.Sprite_title:setSpriteFrame(icon)
	local shadowColor = cc.c3b(77, 6, 6)
	local shadowSize = cc.size(2, -2)
	self.Text_name:enableShadow(shadowColor, shadowSize)
	self.Text_scroe:enableShadow(shadowColor, shadowSize)
	self:fitView()
end
function atlantisResultView:fitView(...)
	if display.height >= 1136 then
		return
	end
	local offSetY = 1136 - display.height
	self.Center_Node:setPositionY(self.Center_Node:getPositionY() - offSetY / 2)
	local offsetY = 65
	self.ScrollView_1:setPositionY(self.ScrollView_1:getPositionY() + offsetY)
	local sSize = self.ScrollView_1:getContentSize()
	local scrollH = math.min(sSize.height, self.Center_Node:getPositionY() + self.ScrollView_1:getPositionY())
	self.ScrollView_1:setContentSize(cc.size(sSize.width, scrollH))
	local innerSize = self.ScrollView_1:getInnerContainerSize()
	self.ScrollView_1:setInnerContainerSize(cc.size(innerSize.width, innerSize.height + offsetY))
	self.ScrollView_1:setBounceEnabled(true)
end
function atlantisResultView:initData(data)
	self.data = data
	local player = data.topScorePlayer
	if player and next(player) then
		self.Text_name:setString(serviceFunctions.getKingdomFormatName(player.name, player.kid))
		local totalScore = (player.killPlayerScore or 0) + (player.killBossScore or 0) + (player.occupyScore or 0)
		_ENV = serviceFunctions.getKingdomFormatName(player.name, player.kid)
		serviceFunctions.getKingdomFormatName(player.name, player.kid).var = string.formatnumberthousands(totalScore)
		self.Text_scroe:setString(i18n("atlantiswar_text_0232", serviceFunctions.getKingdomFormatName(player.name, player.kid)))
		self.Sprite_bust:setSpriteFrame(lordLocalData.getPortrait(player.headid))
	end
	local titles = data.titles
	local index = 0
	for i = 1, 4 do
		local title = titles[i]
		if title and type(title) == "table" and next(title) then
			index = index + 1
			self:createTitleSingle(index, title, i)
		end
	end
end
function atlantisResultView:createTitleSingle(index, title, titleType)
	local single = SoraDCreateCSBNode("atlantisResultViewSingle")
	single:addTo(self.Node_title)
	single:setPosition(0, -126 * (index - 1))
	single:setVisible(false)
	ATC = -126 * (index - 1)
	;(-126 * (index - 1))[1] = cca.delay((20 + 5 * index) / 60)
	;(-126 * (index - 1))[2] = cca.callFunc(function()
		single:setVisible(true)
		SoraDCreatAnimation("atlantisResultViewSingle", single, false)
	end)
	;(-126 * (index - 1))[3] = cca.callFunc(function()
		single:setVisible(true)
		SoraDCreatAnimation("atlantisResultViewSingle", single, false)
	end)
	single:runAction(cca.seq(-126 * (index - 1)))
	SoraDGetAllChildFromWidget(single, single)
	single.Text_name:setString(serviceFunctions.getKingdomFormatName(title.name, title.kid))
	single.Text_scroe:setString(string.formatnumberthousands(title.score))
	single.ccs_head = SoraDGetExtendChildFromCCSByName(single, "CCS_commonHead_1")
	single.ccs_head:setTouchEnabled(false)
	single.ccs_head:setHeadSprite(title.headid, title.avatar)
	single.Sprite_title:setSpriteFrame(ATC[titleType].icon)
end
function atlantisResultView:onExitPanel(...)
	local personalData = self.data.personalData
	if personalData and next(personalData) then
		local panel = SoraDCreatePanel("atlantisPersonResultView")
		panel:initData(personalData)
		panel:show()
	end
end
return atlantisResultView
