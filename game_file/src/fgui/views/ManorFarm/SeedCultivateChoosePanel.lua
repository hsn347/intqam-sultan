local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorFarmRead = include("manorFarmRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SeedCultivateChoosePanel = class("SeedCultivateChoosePanel", baseFguiPanel)
function SeedCultivateChoosePanel:ctor(...)
	self.isLRU = true
	SeedCultivateChoosePanel.super.ctor(self, ...)
	print("SeedCultivateChoosePanel:ctor", self.viewName)
end
function SeedCultivateChoosePanel:onInit()
	print("=======SeedCultivateChoosePanel:onInit")
	self.fields.listSeed:setVirtual()
	self.fields.listSeed:setItemRenderer(handler(self, self.itemRenderer_listSeed))
	self.fields.listSeed:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listSeed))
	self.fields.Panel_bg:setString(i18n("farmland_text_10"))
	self.fields.comAdd1:addClickListener(handler(self, self.onClick_comAdd1))
	self.fields.comAdd2:addClickListener(handler(self, self.onClick_comAdd2))
	self.fields.btnGo:setTitle(i18n("common_text_1352"))
	self.fields.btnGo:addClickListener(handler(self, self.onClick_btnGo))
	self.fields.txtTip:setString(i18n("farmland_text_11"))
	_UPVALUE2_ = self.fields.txtTip.setString
	self.comAddList, self.fields.txtTip.setString[1] = self.fields.txtTip.setString, self.fields.comAdd1
	self.comAddList, self.fields.txtTip.setString[2] = self.fields.txtTip.setString, self.fields.comAdd2
	if not SoraDFIsRA() then
		self.fields.comAdd1:fixPos()
		self.fields.comAdd2:fixPos()
	end
end
function SeedCultivateChoosePanel:endShow()
	print("=======SeedCultivateChoosePanel:endShow")
	self.fields.btnGo:setEnabled(true)
	self:initData()
	self:setCurSelectIndex(1)
end
function SeedCultivateChoosePanel:itemRenderer_listSeed(index, obj)
	local data = self.seedsShow[index + 1]
	obj:initData(data.id, data.count)
end
function SeedCultivateChoosePanel:onClick_comAdd1(context)
	SoraDPlaySound()
	self:setCurSelectIndex(1)
end
function SeedCultivateChoosePanel:onClick_comAdd2(context)
	SoraDPlaySound()
	self:setCurSelectIndex(2)
end
function SeedCultivateChoosePanel:onClick_btnGo(context)
	SoraDPlaySound()
	if self.fields.comAdd1.id and self.fields.comAdd2.id then
		self.isUsmComplete = false
		self.isMsgComplete = false
		manorCityCtrl:reqFarmlandMergeSeed(self.param.queue, self.fields.comAdd1.id, self.fields.comAdd2.id)
		self.fields.btnGo:setEnabled(false)
		self.fields.Usm_1:setEffectPath("G_zynt_hecheng.usm", false)
		self.fields.Usm_1:play()
		self.fields.Usm_1:setCompleteCallback(function()
			self:close()
		end)
	else
		SoraDShowMsgTip(i18n("farmland_text_12"))
	end
end
function SeedCultivateChoosePanel:onClickItem_listSeed(context)
	SoraDPlaySound()
	local obj = context.data
	local objSeedId = obj.id
	local curSeedId = self.selectedSeedID[self.curSelectIndex]
	if curSeedId then
		if curSeedId == objSeedId then
			return
		else
			self:updateSeedNum(curSeedId, 1)
		end
	end
	local comAdd = self.comAddList[self.curSelectIndex]
	if self:checkSeedEnough(objSeedId) then
		comAdd:initData(objSeedId)
		self.selectedSeedID[self.curSelectIndex] = objSeedId
		self:updateSeedNum(objSeedId, -1)
	end
	self:updateSeedsShow()
	self:updateBtnState()
end
function SeedCultivateChoosePanel:initData()
	self.selectedSeedID, manorCityCtrl = nil, nil
	self.seeds = manorCityCtrl:getBagSeeds(function(a, b)
		if a.seedData.seedQuality ~= b.seedData.seedQuality then
			return a.seedData.seedQuality > b.seedData.seedQuality
		end
		return a.seedData.seedID < b.seedData.seedID
	end)
	self:updateSeedsShow()
	self.fields.comAdd1:initData(nil)
	self.fields.comAdd2:initData(nil)
	self:updateBtnState()
end
function SeedCultivateChoosePanel:updateBtnState()
	if self:canMerge() then
		self.fields.btnGo:setGrayed(false)
	else
		self.fields.btnGo:setGrayed(true)
	end
end
function SeedCultivateChoosePanel:canMerge()
	local isChoose2 = self.selectedSeedID[1] ~= nil and self.selectedSeedID[2] ~= nil
	if not isChoose2 then
		return false
	end
	return manorFarmRead.getCanMerge(self.selectedSeedID[1], self.selectedSeedID[2])
end
function SeedCultivateChoosePanel:checkSeedEnough(seedId)
	local num = 0
	for i, v in ipairs(self.seeds) do
		if v.id == seedId then
			num = v.count
			break
		end
	end
	return 0 < num
end
function SeedCultivateChoosePanel:updateSeedNum(seedId, addNum)
	for i, v in ipairs(self.seeds) do
		if v.id == seedId then
			v.count = v.count + addNum
			break
		end
	end
end
function SeedCultivateChoosePanel:setCurSelectIndex(index)
	self.curSelectIndex = index
	if self.curSelectIndex == 1 then
		self.fields.comAdd1:setBtnSelected(true)
		self.fields.comAdd2:setBtnSelected(false)
	elseif self.curSelectIndex == 2 then
		self.fields.comAdd1:setBtnSelected(false)
		self.fields.comAdd2:setBtnSelected(true)
	end
end
function SeedCultivateChoosePanel:updateSeedsShow()
	local _ENV, ret
	for i, v in ipairs(self.seeds) do
		if v.count > 0 then
			table.insert(ret, v)
		end
	end
	self.seedsShow = ret
	self.fields.listSeed:setNumItems(#self.seedsShow)
end
return SeedCultivateChoosePanel
