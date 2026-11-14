local FACETREASUREVIEW_FBSUCCESS = 1
local FACETREASUREVIEW_FBNOTBIND = 2
local FACETREASUREVIEW_FBNOTLOGIN = 3
local FACETREASUREVIEW_FBFAILD = 4
local FaceTreasurePlayer = class("faceTreasurePlayer", function(target)
	if target == nil then
		return SoraDCreateBasePanel("faceTreasurePlayer")
	end
	return target
end)
function FaceTreasurePlayer:ctor()
	self.selfInfo, _ENV, self.fbHeadFileFlag = nil, nil, "FaceBookAvatar_"
	self.loadHead = false
	self.isHelped = false
	self.fatherClass = nil
	self.txtInvite = SoraDGetChildByName(self, "Text_invite")
	self.imgPlayer = SoraDGetChildByName(self, "Image_player")
	self.txtPlayer = SoraDGetChildByName(self, "Text_player")
	self.imgWarning = SoraDGetChildByName(self, "Image_warning")
	self.btnInvite = SoraDGetChildByName(self, "Button_invite")
	self.btnInvite:addTouchEventListener(handler(self, self.btnInviteClick))
	self.imgPlayer:setTouchEnabled(true)
	self.imgPlayer:addTouchEventListener(handler(self, self.btnHeadClick))
	self.txtInvite:setString(i18n("common_text_189"))
	function self.imgPlayer.isAlive(...)
		return true
	end
end
function FaceTreasurePlayer:initData(info, isEmpty)
	self.selfInfo = info
	self.isEmpty = isEmpty or false
	self:initView()
end
function FaceTreasurePlayer:initView(...)
	self:setMode(self.isEmpty)
	if self.isEmpty then
	else
		if self.selfInfo.fHead and not self.loadHead then
			local ocx = self.imgPlayer
			SoraDGetHTTPPic(self.selfInfo.fHead, self.fbHeadFileFlag .. self.selfInfo.fID, ocx, self.imgPlayer:getContentSize())
			self.loadHead = true
		end
		self.txtPlayer:setString(self.selfInfo.fName)
	end
end
function FaceTreasurePlayer:setMode(bool)
	self.imgPlayer:setVisible(not bool)
	self.txtPlayer:setVisible(not bool)
	self.imgWarning:setVisible(not bool)
	self.btnInvite:setVisible(bool)
	self.txtInvite:setVisible(bool)
end
function FaceTreasurePlayer:btnInviteClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local state = self.fatherClass:getState()
		if FACETREASUREVIEW_FBSUCCESS == state then
			SoraDCreatePanel("faceTreasureInviteView"):show()
		elseif FACETREASUREVIEW_FBNOTBIND == state then
			_ENV = nil
			;(nil).platform = "Facebook"
			SoraDShowMsgTip(i18n("common_text_2240", nil))
		elseif FACETREASUREVIEW_FBNOTLOGIN == state then
			_ENV = i18n("common_text_2240", nil)
			i18n("common_text_2240", nil).platform = "Facebook"
			SoraDShowMsgTip(i18n("common_text_2243", i18n("common_text_2240", nil)))
		elseif FACETREASUREVIEW_FBFAILD == state then
		end
	end
end
function FaceTreasurePlayer:returnFID(...)
	if not self.isEmpty then
		return self.selfInfo.fUserID
	else
		return ""
	end
end
function FaceTreasurePlayer:setFarther(class)
	self.fatherClass = class
end
function FaceTreasurePlayer:setWarning(bool)
	self.imgWarning:setVisible(bool)
	self.isHelped = not bool
end
function FaceTreasurePlayer:btnHeadClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isHelped then
			SoraDShowMsgTip(i18n("common_text_2247"))
		elseif self.selfInfo.fUserID then
			local gametop = gModuleMgr.getObject("gametop")
			local fbTreasureCtrl = gametop.playertop_:getModule("fbTreasureCtrl")
			fbTreasureCtrl:sendHelp(self.selfInfo.fUserID, nil)
			print("self.selfInfo.fUserID", self.selfInfo.fUserID)
		end
	end
end
return FaceTreasurePlayer
