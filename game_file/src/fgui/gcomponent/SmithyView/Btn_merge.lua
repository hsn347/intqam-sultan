local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
_ENV = "equipmentltCtrl"
;("equipmentltCtrl").TAB_COMPONE = 1
local ("equipmentltCtrl").TAB_DECOMPOSITION, TAB_TYPE = 2, "equipmentltCtrl"
local baseComponent = require("fgui.base.baseComponent")
local Btn_merge = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_merge", Btn_merge)
function Btn_merge:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_merge:onShow()
end
function Btn_merge:initData(data, index, curMid, tabType)
	self.data = data
	self.index = index
	self.tabType = tabType
	self.fields.select:setVisible(self.data.mid == curMid)
	self.fields.icon_base:setSpriteFrame(publicRead.getBg(self.data.mid))
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.data.mid))
	self.fields.Text_num:setString(self.data.num)
end
function Btn_merge:btnClick()
	SoraDPlaySound()
	local itemQuality = itemDesRead.getQuality(self.data.mid)
	if self.tabType == TAB_TYPE.TAB_COMPONE and itemQuality >= gQualityDef.ORANGE then
		SoraDShowMsgTip(i18n("equip_text_34"), itemDesRead.getIcon(self.data.mid))
		return
	end
	if self.tabType == TAB_TYPE.TAB_DECOMPOSITION and not equipmentltCtrl.getMaterialIDOfMerge(self.data.mid) then
		SoraDShowMsgTip(i18n("common_text_1353"), itemDesRead.getIcon(self.data.mid, true))
		return
	end
	_ENV = i18n("common_text_1353")
	i18n("common_text_1353").msg = "MESSAGE_UI_EQUIP_MERGE_SELECT"
	i18n("common_text_1353").mid = self.data.mid
	i18n("common_text_1353").index = self.index
	SoraDSendMessage((i18n("common_text_1353")))
end
return Btn_merge
