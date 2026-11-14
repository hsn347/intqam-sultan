local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local commonSelectSingleResource = class("commonSelectSingleResource", function(target)
	return SoraDCreateBasePanel("commonSelectSingleResource")
end)
function commonSelectSingleResource:ctor()
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
	self.itemName = SoraDGetChildByName(self, "Text_name")
	self.checkBox = SoraDGetChildByName(self, "CheckBox_1")
	self.checkBox:addEventListener(handler(self, self.btnClickCallBack))
	self.itemID = 0
	self.count = 0
	self.panelBlack = SoraDGetChildByName(self, "Panel_Black")
	self.panelBlack:setSwallowTouches(false)
	self.panelBlack:setVisible(false)
end
function commonSelectSingleResource:setHandle(handle)
	self.parentCallback = handle
end
function commonSelectSingleResource:initData(params, _parentScroll)
	self.itemID = params.id
	self.count = params.count
	self.item:setScroll(_parentScroll)
	self.item:initData(params.id)
	self.item:setBaseScale(1.0)
	_ENV = nil
	;(nil).name = publicRead.getName(params.id)
	;(nil).count = string.formatnumberthousands(params.count)
	self.itemName:setString(i18n("common_text_1460", nil))
	self:setCheck(false)
	self:checkHeroResource(params.noHero)
end
function commonSelectSingleResource:checkHeroResource(noHero)
	if noHero then
		self.panelBlack:setVisible(true)
		self.checkBox:setTouchEnabled(false)
		self.checkBox:setVisible(false)
		SoraDGetChildByName(self.panelBlack, "Text_Waring"):setString(i18n("common_text_2274"))
	end
end
function commonSelectSingleResource:btnClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self:setCheck(true)
		self.parentCallback(self)
	end
end
function commonSelectSingleResource:enterAutoSelected()
	self:setCheck(true)
	self.parentCallback(self)
end
function commonSelectSingleResource:setCheck(isCheck)
	self.checkBox:setSelected(isCheck)
	self.checkBox:setTouchEnabled(not isCheck)
end
function commonSelectSingleResource:setCheckBoxGray()
	self:setCheck(true)
	self.checkBox:setColor(cc.c3b(77, 77, 77))
end
return commonSelectSingleResource
