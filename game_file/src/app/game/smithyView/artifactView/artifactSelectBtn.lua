local gametop = gModuleMgr.getObject("gametop")
local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
local equipDesRead = include("equipDesRead")
local ArtifactSelectBtn = class("artifactSelectBtn", function(target)
	if target == nil then
		return SoraDCreateBasePanel("artifactSelectBtn")
	end
	return target
end)
function ArtifactSelectBtn:ctor()
	self.curArtifact = 0
	self.myMode = gHeroSelectBannerStyle.inner
	self.speireIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.btnAdd = SoraDGetChildByName(self, "Button_add")
	self.spAdd = SoraDGetChildByName(self, "Sprite_add")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.btnRemove = SoraDGetChildByName(self, "Button_remove")
	self.btnRemove:addTouchEventListener(handler(self, self.btnRemoveClick))
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddCallBack))
end
function ArtifactSelectBtn:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_SELECT", handler(self, self.selectBack))
end
function ArtifactSelectBtn:selectBack(target, data)
	self.curArtifact = data.weaponID
	self:updateView()
end
function ArtifactSelectBtn:setMode(mode)
	self.myMode = mode
	if self.myMode == gHeroSelectBannerStyle.defend then
		self.curArtifact = godArmsCtrl:getDefend()
	end
	self:updateView()
end
function ArtifactSelectBtn:getArtifact()
	return self.curArtifact
end
function ArtifactSelectBtn:refreshPanel(data)
	self.curArtifact = data[1] and data[1] or 0
	self:updateView()
end
function ArtifactSelectBtn:updateView(...)
	if self.curArtifact > 0 then
		self.spAdd:setVisible(false)
		self.btnRemove:setVisible(true)
		_ENV = nil
		;(nil).lv = godArmsCtrl:getArmLvByID(self.curArtifact)
		self.txtName:setString(i18n("common_text_100", nil))
		self.speireIcon:setSpriteFrame(equipDesRead.getArtifactIcon(self.curArtifact))
		self.speireIcon:setVisible(true)
	else
		self.spAdd:setVisible(true)
		self.btnRemove:setVisible(false)
		self.speireIcon:setVisible(false)
		self.txtName:setString(i18n("artifact_title_01"))
	end
end
function ArtifactSelectBtn:btnAddCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).myMode = self.myMode
		uiManager:show("ArtifactSelect", nil)
	end
end
function ArtifactSelectBtn:btnRemoveClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.curArtifact = 0
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_GODEQUIP_SELECT"
		;(nil).weaponID = 0
		SoraDSendMessage(nil)
		if self.myMode == gHeroSelectBannerStyle.defend then
			godArmsCtrl:reqSaveDefend(0)
		end
	end
end
return ArtifactSelectBtn
