local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local cityBuildMgr = include("cityBuildMgr")
local cityBuildConstDef = include("cityBuildConstDef")
local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarframeForgPanel = class("WarframeForgPanel", baseFguiPanel)
function WarframeForgPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WarframeForgPanel:ctor", self.viewName)
end
function WarframeForgPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WarframeForgPanel:onInit()
	print("=======WarframeForgPanel:onInit")
	self.tag = 1
	_ENV, _ENV, self.preTag = "=======WarframeForgPanel:onInit", print, 0
	;("=======WarframeForgPanel:onInit").lv = 13
	;("=======WarframeForgPanel:onInit").name = i18n("gilt_armor_text02")
	_ENV, print[1], ("=======WarframeForgPanel:onInit").tag = "=======WarframeForgPanel:onInit", "=======WarframeForgPanel:onInit", 1
	;("=======WarframeForgPanel:onInit").lv = 14
	;("=======WarframeForgPanel:onInit").name = i18n("gilt_armor_text01")
	self.armorLvCfg, print[2], ("=======WarframeForgPanel:onInit").tag = print, "=======WarframeForgPanel:onInit", 2
	self.fields.Com_title:initData(i18n("Soldiers_armor_text_19"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.fields.Button_Wear:setString(i18n("Soldiers_armor_text_47"))
	self.fields.Button_Wear:addClickListener(handler(self, self.btnWearClick))
	self.soldiersArmor = armorSystemRead:getArmorCfg(self.armorLvCfg[self.tag].lv)
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List_tab:setItemRenderer(handler(self, self.onTabRender))
	self.fields.List_tab:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onTabClick))
end
function WarframeForgPanel:onTabRender(index, obj)
	obj:getController("c1"):setSelectedIndex(index)
	obj:setTitle(self.armorLvCfg[index + 1].name)
	obj:setSelected(index + 1 == self.tag)
	obj:setWidth(self.fields.List_tab:getWidth() / #self.armorLvCfg)
end
function WarframeForgPanel:onTabClick()
	SoraDPlaySound()
	self.tag = self.fields.List_tab:getSelectedIndex() + 1
	self:updateByTab()
end
function WarframeForgPanel:updateByTab()
	if self.preTag ~= self.tag then
		self.soldiersArmor = armorSystemRead:getArmorCfg(self.armorLvCfg[self.tag].lv)
		self:updateData()
		self.preTag = self.tag
	end
	self.fields.bg:setURL(self.tag == 2 and "bg_ghyz_bj04.png" or "bg_ghyz_bj01.png")
end
function WarframeForgPanel:onShow()
	print("=======WarframeForgPanel:onShow")
	local isGilderOpen = SoraDIsGildedArmorOpen()
	self.fields.List_tab:setVisible(isGilderOpen)
	self.fields.n26:setVisible(isGilderOpen)
	self.tag = isGilderOpen and 2 or 1
	self.fields.List_tab:setNumItems(#self.armorLvCfg)
	self:updateByTab()
	armorSystemCtrl:reqArmorSystemInit()
end
function WarframeForgPanel:updateWearButtonVisible()
	local isVisible = false
	if self.armorLvCfg[self.tag].lv == 14 then
		for _, v in ipairs(self.soldiersArmor) do
			if armorSystemCtrl:getArmorNumByID(v.armorId) > 0 and 0 < armorSystemCtrl:getArmyNumByArmorId(v.armorId) then
				_ENV = armorSystemCtrl
				armorSystemCtrl.isArmorID = true
				armorSystemCtrl.armorID = v.armorId
				if SoraDIsGildedArmorOpen(armorSystemCtrl) then
					isVisible = true
					break
				end
			end
		end
		self.fields.Button_Wear:setVisible(isVisible and commonCheck.GILT_ARMOR_WEAR)
	else
		for _, v in ipairs(self.soldiersArmor) do
			if armorSystemCtrl:getArmorNumByID(v.armorId) > 0 and 0 < armorSystemCtrl:getArmyNumByArmorId(v.armorId) then
				_ENV = armorSystemCtrl
				armorSystemCtrl.isArmorID = true
				armorSystemCtrl.armorID = v.armorId
				if SoraDIsBrave8Level(armorSystemCtrl) then
					isVisible = true
					break
				end
			end
		end
		self.fields.Button_Wear:setVisible(isVisible and commonCheck.WARFRAME_WEAR)
	end
	self.fields.n3:setVisible(self.fields.Button_Wear:isVisible())
end
function WarframeForgPanel:onItemRederer(index, target)
	target:initData(self.soldiersArmor[index + 1].armorId)
end
function WarframeForgPanel:updateData()
	SoraDCloseLoading(self)
	self.fields.List:setNumItems(#self.soldiersArmor)
	self.fields.List:playListAction()
	self:updateWearButtonVisible()
end
function WarframeForgPanel:btnWearClick(target, eventType)
	SoraDPlaySound()
	if worldMapDefine.isInWarForbidSoldier() then
		return
	end
	SoraDShowLoading(self)
	armorSystemCtrl:reqOneKeyWearArmor(self.armorLvCfg[self.tag].lv)
end
function WarframeForgPanel:btnHelpClick()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(_G.gSDKDef.FAQSingleType.STAR_BRAVE_STATUS)
end
return WarframeForgPanel
