local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisMarshalView = class("atlantisMarshalView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisMarshalView")
	end
	return target
end)
function atlantisMarshalView:ctor()
	self:initWidget()
	self:req4Data()
end
function atlantisMarshalView:req4Data(...)
	atlantisWarCtrl:reqFortCmdPostData()
end
function atlantisMarshalView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_FORTCMDPOSTDATA", handler(self, self.updateMarshalInfo))
end
function atlantisMarshalView:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.Button_help:addTouchEventListener(handler(self, self.btnHelpClick))
	self.Text_title:setString(i18n("atlantiswar_text_0111"))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).var = time
		return i18n("atlantiswar_text_0125", nil)
	end)
	self.Text_time:setTimeEndListener(handler(self, self.refreshMarshalTime))
	self:refreshMarshalTime()
	local textW = self.Text_time:getContentSize().width
	if 400 < textW then
		textW = 400
		SoraDSetTextWidthHeight(self.Text_time, cc.size(textW, 30))
	end
	self.icon_hourglass:setPositionX(SoraDFSign(textW / 2 + 20))
	self.scroll = SoraDCreatePanelByCloneNode(self.ScrollView_1, "commonAutoScrollList")
	self.scroll:setSingleCCS("atlantisMarshalViewSingle")
	self:initCriSpriteEffect()
	self:fitView()
end
function atlantisMarshalView:initCriSpriteEffect(...)
	local criSprite = cc.criSprite.createCriSprite("shuaiweizd22.usm", false, true, nil)
	criSprite:addTo(self.Center_Node, -1)
	criSprite:setPosition(0, 28)
	criSprite:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.Image_bg:setVisible(false)
	self.frame_shmc_titlebg_01_1:setVisible(false)
	self.Sprite_line:setVisible(false)
end
function atlantisMarshalView:fitView(...)
	if display.height < 1000 then
		local scale = (display.height - 853) / 147 * 0.1 + 0.9
		self.Center_Node:setScale(scale)
	end
end
function atlantisMarshalView:updateMarshalInfo(target, event)
	local rspdata = event.rspdata
	_UPVALUE3_ = nil
	;(nil)[1] = 902
	;(nil)[2] = 903
	local (nil)[3], buildings = 904, nil
	local _ENV, config = 902, 902
	for i, v in ipairs(buildings) do
		local campScore = rspdata[tostring(v)].campScore
		local cmdPostOwner = rspdata[tostring(v)].cmdPostOwner
		local _ENV, scoreData = v, v
		for __, v in ipairs(campScore) do
			_ENV = nil
			;(nil).kid = atlantisWarCtrl:getCampKid(v.camp)
			;(nil).camp = v.camp
			;(nil).score = v.score or 0
			;(nil).t = v.t or 0
			table.insert(scoreData, nil)
		end
		_ENV = ipairs(campScore)
		ipairs(campScore).buildId = v
		ipairs(campScore).scoreData = scoreData
		ipairs(campScore).cmdPostOwner = cmdPostOwner
		table.insert(config, ipairs(campScore))
	end
	_ENV = rspdata[tostring(v)].campScore
	rspdata[tostring(v)].campScore.scroll = self.scroll
	self.scroll:updateScrollView(cc.size(600, 300), config, nil, rspdata[tostring(v)].campScore)
end
function atlantisMarshalView:refreshMarshalTime(...)
	local time = atlantisWarCtrl:getMarshalTime()
	if 0 < time then
		self.Text_time:beginTime(time)
	else
		self.Node_time:setVisible(false)
	end
end
function atlantisMarshalView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "atlantiswar_text_0112"
		;("atlantiswar_text_0112").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("atlantiswar_text_0112"), "atlantiswar_text_0112")
	end
end
return atlantisMarshalView
