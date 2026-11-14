local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceMobMSingle = class("allianceMobMSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMobMSingle")
	end
	return target
end)
function allianceMobMSingle:ctor()
	self.Image_curBg = SoraDGetChildByName(self, "Image_curBg")
	self.Sprite_index = SoraDGetChildByName(self, "Sprite_index")
	self.Text_index = SoraDGetChildByName(self, "Text_index")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_point = SoraDGetChildByName(self, "Text_point")
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.Sprite_rank = SoraDGetChildByName(self, "Sprite_rank")
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setSwallowTouches(false)
	self.Panel_touch:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function allianceMobMSingle:initData(data, otherData)
	self.data = data
	self.scroll = otherData.scroll
	self.view = otherData.view
	self.ccs_head:setHeadSprite(data.uInfo.headid, data.uInfo.avatar)
	self.ccs_head:setPlayerID(data.uid)
	local isMe = data.uid == lordInfoCtrl:getLordInfo().base.uid
	self.ccs_head:setTouchEnabled(not isMe)
	if data.rank <= RANK_TOP_SPECIAL then
		self.Image_curBg:loadTexture("frame_alliance_pank_0" .. data.rank .. ".png", ccui.TextureResType.plistType)
		self.Sprite_index:setSpriteFrame("icon_ranking_" .. data.rank .. ".png")
		self.Sprite_index:setVisible(true)
		self.Text_index:setVisible(false)
	else
		self.Image_curBg:loadTexture(isMe and "frame_alliance_pank_05.png" or "frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		self.Sprite_index:setVisible(false)
		self.Text_index:setVisible(true)
		self.Text_index:setString(data.rank)
	end
	self.Sprite_rank:setSpriteFrame(allianceDesRead.getIcon(data.alliancerank))
	self.Text_name:setString(data.uInfo.nickName)
	self.Text_point:setString(string.formatnumberthousands(data.score))
end
function allianceMobMSingle:btnClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		_ENV = "node is not on view"
		;("node is not on view").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;("node is not on view").playerID = self.data.uid
		;("node is not on view").kid = self.data.uInfo.kid
		SoraDSendMessage("node is not on view")
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return allianceMobMSingle
