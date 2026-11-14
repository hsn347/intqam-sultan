local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicWarBlessSingle = class("epicWarBlessSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicWarBlessSingle")
	end
	return target
end)
function epicWarBlessSingle:ctor()
	self.Image_buff = SoraDGetChildByName(self, "Image_buff")
	self.Image_base = SoraDGetChildByName(self, "Image_base")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Node_choose = SoraDGetChildByName(self, "Node_choose")
	SoraDCreatAnimation("animationQFGXZ"):addTo(self.Node_choose)
	self.Node_choose:setVisible(false)
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setSwallowTouches(false)
	self.Panel_touch:addTouchEventListener(handler(self, self.btnChooseCallBack))
end
function epicWarBlessSingle:initData(data, otherData)
	self.tacticsId = data.id
	self.index = data.index
	self.chooseIndex = otherData.index
	self.mithrilCount = epicWarCtrl:getMithrilCount()
	local icon = epicWarltCtrl.getBlessTacticsIcon(self.tacticsId)
	self.Image_buff:loadTexture(icon, ccui.TextureResType.plistType)
	local base = epicWarltCtrl.getBlessTacticsBase(self.tacticsId)
	self.Image_base:loadTexture(base, ccui.TextureResType.plistType)
	local name = epicWarltCtrl.getBlessTacticsName(self.tacticsId)
	self.Text_name:setString(i18n(name))
	local des = epicWarltCtrl.getBlessTacticsDes(self.tacticsId)
	self.Text_des:setString(des)
	self.Node_choose:setVisible(self.chooseIndex == self.index)
end
function epicWarBlessSingle:btnChooseCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_EPICBATTLE_UPDATE_BLESS_CHOOSE"
		;(nil).index = self.index
		SoraDSendMessage(nil)
	end
end
return epicWarBlessSingle
