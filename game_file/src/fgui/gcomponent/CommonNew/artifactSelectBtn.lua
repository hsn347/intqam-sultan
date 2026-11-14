local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local artifactSelectBtn = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/artifactSelectBtn", artifactSelectBtn)
function artifactSelectBtn:onInit()
	self.curArtifact = 0
	self.myMode = gHeroSelectBannerStyle.inner
	self.fields.Button_remove:addClickListener(handler(self, self.btnRemoveClick))
	self:addClickListener(handler(self, self.btnAddCallBack))
end
function artifactSelectBtn:onShow()
end
function artifactSelectBtn:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_SELECT", handler(self, self.selectBack))
end
function artifactSelectBtn:selectBack(target, data)
	self.curArtifact = data.weaponID
	self:updateView()
end
function artifactSelectBtn:setMode(mode)
	self.myMode = mode
	if self.myMode == gHeroSelectBannerStyle.defend then
		self.curArtifact = godArmsCtrl:getDefend()
	end
	self:updateView()
end
function artifactSelectBtn:getArtifact()
	return self.curArtifact
end
function artifactSelectBtn:refreshPanel(data)
	self.curArtifact = data[1] and data[1] or 0
	self:updateView()
end
function artifactSelectBtn:updateView()
	if self.curArtifact > 0 then
		self.controllers.c2:setSelectedIndex(1)
		_ENV = nil
		;(nil).lv = godArmsCtrl:getArmLvByID(self.curArtifact)
		self.fields.title:setString(i18n("common_text_100", nil))
		self.fields.icon:setSpriteFrame(equipDesRead.getArtifactIcon(self.curArtifact))
	else
		self.controllers.c2:setSelectedIndex(0)
		self.fields.title:setString(i18n("artifact_title_01"))
	end
end
function artifactSelectBtn:btnAddCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).myMode = self.myMode
	uiManager:show("ArtifactSelect", nil)
end
function artifactSelectBtn:btnRemoveClick()
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
return artifactSelectBtn
