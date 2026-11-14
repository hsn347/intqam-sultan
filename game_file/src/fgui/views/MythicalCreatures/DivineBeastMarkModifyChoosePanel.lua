local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkModifyChoosePanel = class("DivineBeastMarkModifyChoosePanel", baseFguiPanel)
local buffDesRead = include("buffDesRead")
local divineBeastMarkRead = include("divineBeastMarkRead")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local constantRead = include("constantRead")
local publicUtil = include("publicUtil")
function DivineBeastMarkModifyChoosePanel:ctor(...)
	DivineBeastMarkModifyChoosePanel.super.ctor(self, ...)
	print("DivineBeastMarkModifyChoosePanel:ctor", self.viewName)
	self.debug = true
end
function DivineBeastMarkModifyChoosePanel:onInit()
	print("=======DivineBeastMarkModifyChoosePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Divine_beast_mark_text_80"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_sure:addClickEventListener(handler(self, self.onSureClick))
	self.fields.Btn_sure:setTitle(i18n("Divine_beast_mark_text_80"))
	self.fields.text_tip:setString(i18n("Divine_beast_mark_refinement_01"))
	self.fields.btn_1:addEventListener(fgui.UIEventType.Click, handler(self, self.onChooseClick))
	self.fields.btn_2:addEventListener(fgui.UIEventType.Click, handler(self, self.onChooseClick))
	self.itemData = constantRead.getConstValueArray("DIVINE_BEAST_MARK_FIX_RANDOM_BUFF")
	dump(self.itemData, "self.itemData")
	self.mark = self.param.mark
	self.buffIdx = 1
	self.fields.selected_1:setVisible(true)
	self.fields.selected_2:setVisible(false)
end
function DivineBeastMarkModifyChoosePanel:onShow()
	print("=======DivineBeastMarkModifyChoosePanel:onShow")
	self:updateData()
	self:updateView()
end
function DivineBeastMarkModifyChoosePanel:initData(mark)
	self.mark = mark
	self:updateData()
	self:updateView()
end
function DivineBeastMarkModifyChoosePanel:updateData()
	local _ENV, pool
	local _ENV, poolMapBuff
	buffDesRead = nil
	;(nil)[1] = "count"
	;(nil)[2] = "id"
	local poolList = serviceFunctions.tableFormat(self.mark.markCfg.random_pool1, nil)
	for i, v in ipairs(poolList) do
		local poolCfg = divineBeastMarkRead.getRandomPool(v.id)
		for i, v2 in ipairs(poolCfg.pool) do
			if not poolMapBuff[v2.buffType] then
				table.insert(pool, v2)
				poolMapBuff[v2.buffType] = true
			end
		end
	end
	self.showList, _ENV = ipairs(poolList)
	for i, v in ipairs(pool) do
		if v.buffType ~= self.mark.randomBuff1 and v.buffType ~= self.mark.randomBuff2 then
			local randomBuffCfg = divineBeastMarkRead.getRandomEffect(v.buffType, self.mark.markCfg.quality, self.mark.lv)
			_ENV = self.mark.lv
			self.mark.lv.desc = buffDesRead.getTitleWithValue(v.buffType, SoraDPreciseDecimal(randomBuffCfg.value[self.mark.markCfg.randombuff_type] / 10, 2))
			self.mark.lv.buffType = v.buffType
			table.insert(self.showList, self.mark.lv)
		end
	end
	self.selectedBuffType = nil
	self.fields.list:setNumItems(#self.showList)
	self.itemCount = publicUtil.getCount(self.itemData[1])
	self.fields.Btn_sure:setCost(self.itemData[1], self.itemData[2], true, true)
	self.fields.Btn_sure:setEnabled(false)
end
local colorGray = cc.c3b(116, 110, 101)
local colorGreen = cc.c3b(240, 230, 210)
function DivineBeastMarkModifyChoosePanel:updateView()
	local markCfg = self.mark.markCfg
	local _ENV, lastRandombuffs
	for i = 1, 2 do
		local randomBuffLv = markCfg.randombuff_lv[i]
		local randomBuff = self.mark["randomBuff" .. i]
		local randomBuffCfg = self.mark["randomBuffCfg" .. i]
		lastRandombuffs[i] = randomBuff
		self.fields["text_buff" .. i]:setVisible(randomBuffLv ~= nil)
		self.fields["text_value" .. i]:setVisible(randomBuff ~= 0)
		self.fields["text_lock" .. i]:setVisible(randomBuff == 0)
		self.fields["btn_" .. i]:setVisible(randomBuff ~= 0)
		if randomBuffLv then
			local buffStr = randomBuff == 0 and i18n("Divine_beast_mark_text_18") or buffDesRead.getTitleBase(randomBuff, false, true)
			if randomBuff == 0 then
				_ENV = true
				;(true).num = randomBuffLv
				if i18n("Divine_beast_mark_text_17", true) then
					goto lbl_99
				end
			end
			local valueStr = buffDesRead.getTitleValueWithValue(randomBuff, SoraDPreciseDecimal(randomBuffCfg.value[markCfg.randombuff_type] / 10, 2), false)
			::lbl_99::
			self.fields["text_buff" .. i]:setString(buffStr)
			self.fields["text_buff" .. i]:setColor(randomBuff == 0 and colorGray or colorGreen)
			if randomBuff ~= 0 then
				self.fields["text_value" .. i]:setString(valueStr)
			else
				self.fields["text_lock" .. i]:setString(valueStr)
			end
			if self.lastRandomBuffs ~= nil and self.lastRandomBuffs[i] ~= randomBuff and self.fields["Ani_buff" .. i] then
				self.fields["Ani_buff" .. i]:setVisible(true)
				self.fields["Ani_buff" .. i]:setAllFrameNameOnce("ssyj_effect_wzjs_%02d.png", 1, false)
			end
		end
	end
	self.lastRandomBuffs = lastRandombuffs
end
function DivineBeastMarkModifyChoosePanel:onItemRenderer(index, obj)
	local showData = self.showList[index + 1]
	if obj.showDataValue == nil then
		obj:addClickEventListener(handler(self, self.onDataClick))
	end
	obj:fixChildrenPos()
	obj:setTitle(showData.desc)
	obj.showDataValue = showData.buffType
	print("showData.buffType", showData.buffType, self.selectedBuffType)
	obj:setSelected(self.selectedBuffType == showData.buffType)
end
function DivineBeastMarkModifyChoosePanel:onDataClick(sender)
	SoraDPlaySound()
	self.selectedBuffType = sender.showDataValue
	self.fields.Btn_sure:setEnabled(true)
	print("self.selectedBuffType", self.selectedBuffType)
	self.fields.list:setNumItems(#self.showList)
end
function DivineBeastMarkModifyChoosePanel:onSureClick(sender)
	SoraDPlaySound()
	if self.selectedBuffType == nil then
		return
	end
	if self.itemCount <= 0 then
		SoraDShowMsgTip(i18n("Divine_beast_mark_text_84"))
		return
	end
	divineBeastMarkCtrl:sendModifyRandomBuff(self.mark.bagMarkId, self.buffIdx, self.selectedBuffType)
	self.selectedBuffType = nil
	self.fields.Btn_sure:setEnabled(false)
	self.fields.list:setNumItems(#self.showList)
end
function DivineBeastMarkModifyChoosePanel:onChooseClick(sender)
	if sender:getSender() == self.fields.btn_1 then
		if self.buffIdx == 1 then
			return
		end
		self.buffIdx = 1
		self.fields.selected_1:setVisible(true)
		self.fields.selected_2:setVisible(false)
	elseif sender:getSender() == self.fields.btn_2 then
		if self.buffIdx == 2 then
			return
		end
		self.buffIdx = 2
		self.fields.selected_1:setVisible(false)
		self.fields.selected_2:setVisible(true)
	end
	self.selectedBuffType = nil
	self.fields.Btn_sure:setEnabled(false)
	self.fields.list:setNumItems(#self.showList)
end
return DivineBeastMarkModifyChoosePanel
