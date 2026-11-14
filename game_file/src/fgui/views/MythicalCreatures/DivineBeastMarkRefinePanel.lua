local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkRefinePanel = class("DivineBeastMarkRefinePanel", baseFguiPanel)
local divineBeastMarkRead = include("divineBeastMarkRead")
local buffDesRead = include("buffDesRead")
local constantRead = include("constantRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
function DivineBeastMarkRefinePanel:ctor(...)
	DivineBeastMarkRefinePanel.super.ctor(self, ...)
	print("DivineBeastMarkRefinePanel:ctor", self.viewName)
	self.debug = true
end
function DivineBeastMarkRefinePanel:onInit()
	print("=======DivineBeastMarkRefinePanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_1341"), handler(self, self.onClickClose))
	self.fields.Com_MC_Mark:forbidLongPress()
	self.fields.btn_1:addClickEventListener(handler(self, self.onChooseClick), 1)
	self.fields.btn_2:addClickEventListener(handler(self, self.onChooseClick), 2)
	self.fields.btn_1:setTitle(i18n("Divine_beast_mark_refinement_02"))
	self.fields.btn_2:setTitle(i18n("Divine_beast_mark_refinement_02"))
	self.fields.btn_detail:setTitle(i18n("Divine_beast_mark_refinement_03"))
	self.fields.btn_detail:addClickEventListener(handler(self, self.onDetailClick))
	self.fields.text_tip:setString(i18n("Divine_beast_mark_text_81"))
	self.fields.Text_title:setString(i18n("common_text_1370"))
	self.fields.btn_modify:setTitle(i18n("Divine_beast_mark_text_80"))
	self.fields.btn_modify:addClickEventListener(handler(self, self.onModifyClick))
	self.fields.btn_replace1:setTitle(i18n("common_text_1371"))
	self.fields.btn_replace1:addClickEventListener(handler(self, self.onReplaceClick), 1)
	self.fields.btn_replace2:setTitle(i18n("common_text_1371"))
	self.fields.btn_replace2:addClickEventListener(handler(self, self.onReplaceClick), 2)
	self.fields.Com_MC_Have:setIsKeepFixPos(true)
	self.view:fixChildrenPos()
end
function DivineBeastMarkRefinePanel:endShow()
	print("=======DivineBeastMarkRefinePanel:endShow")
	if self.btnPosData1 == nil then
		self.btnX1 = self.fields.btn_1:getX()
		self.btnY1 = self.fields.btn_1:getY()
		local iconCost1X = self.fields.icon_cost1:getX()
		local textCost1X = self.fields.text_cost1:getX()
		local iconCost1Y = self.fields.icon_cost1:getY()
		local textCost1Y = self.fields.text_cost1:getY()
		_UPVALUE2_, _ENV = nil, self.fields.text_cost1
		_UPVALUE2_, self.fields.text_cost1.btn_1, (nil)[1] = nil, nil, 0
		_UPVALUE2_, self.fields.text_cost1.btn_1, (nil)[2] = nil, nil, 0
		_UPVALUE2_, self.fields.text_cost1.icon_cost1, (nil)[1] = nil, nil, iconCost1X - self.btnX1
		_UPVALUE2_, self.fields.text_cost1.icon_cost1, (nil)[2] = nil, nil, iconCost1Y - self.btnY1
		self.btnPosData1, self.fields.text_cost1.text_cost1, (nil)[1] = self.fields.text_cost1, nil, textCost1X - self.btnX1
		self.btnPosData1, self.fields.text_cost1.text_cost1, (nil)[2] = self.fields.text_cost1, nil, textCost1Y - self.btnY1
		self.btnX2 = self.fields.btn_2:getX()
		self.btnY2 = self.fields.btn_2:getY()
		local iconCost2X = self.fields.icon_cost2:getX()
		local textCost2X = self.fields.text_cost2:getX()
		local iconCost2Y = self.fields.icon_cost2:getY()
		local textCost2Y = self.fields.text_cost2:getY()
		_UPVALUE2_, _ENV = nil, self.fields.text_cost2
		_UPVALUE2_, self.fields.text_cost2.btn_2, (nil)[1] = nil, nil, 0
		_UPVALUE2_, self.fields.text_cost2.btn_2, (nil)[2] = nil, nil, 0
		_UPVALUE2_, self.fields.text_cost2.icon_cost2, (nil)[1] = nil, nil, iconCost2X - self.btnX2
		_UPVALUE2_, self.fields.text_cost2.icon_cost2, (nil)[2] = nil, nil, iconCost2Y - self.btnY2
		self.btnPosData2, self.fields.text_cost2.text_cost2, (nil)[1] = self.fields.text_cost2, nil, textCost2X - self.btnX2
		self.btnPosData2, self.fields.text_cost2.text_cost2, (nil)[2] = self.fields.text_cost2, nil, textCost2Y - self.btnY2
	end
	self.centerX = self:getSize().width / 2
	self.mark = self.param.mark
	self.bagMarkId = self.mark.bagMarkId
	self:initData(self.mark)
end
local colorGray = cc.c3b(240, 230, 210)
local colorGreen = cc.c3b(240, 230, 210)
function DivineBeastMarkRefinePanel:initData()
	local mark = divineBeastMarkCtrl:getMarkByBagMarkId(self.bagMarkId)
	self.mark = mark
	self.fields.Com_MC_Mark:initData(mark.markId)
	self.fields.Com_MC_Mark:getSetupItemUI():hideSelf()
	local markCfg = mark.markCfg
	self.itemId = markCfg.refinement_item[1]
	self.cost = markCfg.refinement_item[2]
	self.fields.icon_item:setURL(publicRead.getIcon(self.itemId))
	divineBeastMarkCtrl = publicRead.getIcon(self.itemId)
	publicRead.getIcon(self.itemId).lv = mark.lv
	self.fields.lv_now:setString(i18n("common_text_100", publicRead.getIcon(self.itemId)))
	self.fields.txt_name:setString(i18n(markCfg.name))
	local lvCfg = self.mark.lvCfg
	local starCfg = divineBeastMarkRead.getStarCfg(mark.star)
	self.fields.txt_fc:setString(lvCfg.power + starCfg.power)
	self.fields.Com_MC_Stars:initData(mark.star)
	local elements = markCfg.elements
	local elements_lv = markCfg.elements_lv
	dump(self.mark, "self.mark")
	local randomElement = self.mark.randomElem or 0
	for index = 1, 5 do
		local obj = self.fields["element" .. index]
		local element = elements[index]
		obj:setVisible(element ~= nil)
		if element ~= nil then
			element = element == 5 and 0 < randomElement and randomElement or element
			obj:setURL(divineBeastMarkRead.getElementIcon(element))
			obj:setGrayed((elements_lv[index] or 0) > (mark.lv or 0))
		end
	end
	local divineBeastMarkCtrl, lastRandombuffs = (for index), 1
	_ENV = i18n(markCfg.name)
	i18n(markCfg.name)[1] = "count"
	i18n(markCfg.name)[2] = "pool"
	local random_text_pool = serviceFunctions.tableFormat(markCfg.random_text_pool, i18n(markCfg.name))
	for i = 1, 2 do
		local randomBuffLv = markCfg.randombuff_lv[i]
		local randomBuff = mark["randomBuff" .. i]
		local randomBuffCfg = mark["randomBuffCfg" .. i]
		lastRandombuffs[i] = randomBuff
		self.fields["text_buff" .. i]:setVisible(randomBuffLv ~= nil)
		self.fields["text_value" .. i]:setVisible(randomBuff ~= 0)
		self.fields["text_lock" .. i]:setVisible(randomBuff == 0)
		self.fields["btn_" .. i]:setVisible(randomBuff ~= 0)
		self.fields["bg" .. i]:setVisible(randomBuff ~= 0)
		self.fields["icon_cost" .. i]:setVisible(randomBuff ~= 0)
		self.fields["text_cost" .. i]:setVisible(randomBuff ~= 0)
		self.fields["icon_cost" .. i]:setURL(publicRead.getIcon(self.itemId))
		self.fields["text_cost" .. i]:setString("X" .. self.cost)
		self.fields["text_tip" .. i]:setVisible(randomBuff ~= 0)
		if randomBuffLv then
			local buffStr = randomBuff == 0 and i18n("Divine_beast_mark_text_18") or buffDesRead.getTitleBase(randomBuff, false, true)
			if randomBuff == 0 then
				divineBeastMarkCtrl = true
				;(true).num = randomBuffLv
				if i18n("Divine_beast_mark_text_17", true) then
					goto lbl_286
				end
			end
			local valueStr = buffDesRead.getTitleValueWithValue(randomBuff, SoraDPreciseDecimal(randomBuffCfg.value[markCfg.randombuff_type] / 10, 2), false)
			::lbl_286::
			self.fields["text_buff" .. i]:setString(buffStr)
			self.fields["text_buff" .. i]:setColor(randomBuff == 0 and colorGray or colorGreen)
			if randomBuff ~= 0 then
				self.fields["text_value" .. i]:setString(valueStr)
				local buffCount = divineBeastMarkCtrl:getRefineCount(self.mark.markId, i)
				local lastBuffNumText, needCount
				for i2, v2 in ipairs(random_text_pool) do
					if buffCount < v2.count then
						lastBuffNumText = divineBeastMarkRead.getTextPoolText(v2.pool)
						needCount = v2.count - buffCount
						break
					end
				end
				print("lastBuffNumText", lastBuffNumText, needCount)
				if lastBuffNumText == nil then
					self.fields["text_tip" .. i]:setVisible(false)
				else
					divineBeastMarkCtrl = publicRead.getIcon(self.itemId)
					publicRead.getIcon(self.itemId).num = needCount
					self.fields["text_tip" .. i]:setString(i18n(lastBuffNumText, publicRead.getIcon(self.itemId)))
				end
			else
				self.fields["text_lock" .. i]:setString(valueStr)
			end
			print("self.lastRandomBuffs", valueStr)
			if self.lastRandomBuffs ~= nil and self.lastRandomBuffs[i] ~= randomBuff and self.fields["Ani_buff" .. i] then
				self.fields["Ani_buff" .. i]:setVisible(true)
				self.fields["Ani_buff" .. i]:setAllFrameNameOnce("ssyj_effect_wzjs_%02d.png", 1, false)
			end
			local refineBuff = mark.refineBuffs and mark.refineBuffs[i] or 0
			local isCurRefineBuff = refineBuff ~= 0
			self.fields["text_buff_new" .. i]:setVisible(isCurRefineBuff)
			self.fields["text_value_new" .. i]:setVisible(isCurRefineBuff)
			self.fields["line_" .. i]:setVisible(isCurRefineBuff)
			self.fields["btn_replace" .. i]:setVisible(isCurRefineBuff)
			if isCurRefineBuff then
				local newBuff = refineBuff
				self.fields["text_buff_new" .. i]:setString(buffDesRead.getTitleBase(newBuff, false, true))
				local newRandomBuffCfg = divineBeastMarkRead.getRandomEffect(newBuff, self.mark.markCfg.quality, self.mark.lv)
				self.fields["text_value_new" .. i]:setString(buffDesRead.getTitleValueWithValue(newBuff, SoraDPreciseDecimal(newRandomBuffCfg.value[markCfg.randombuff_type] / 10, 2), false))
			end
			print("isCurRefineBuff", isCurRefineBuff, "btn_replace" .. i)
			local btnX = self["btnX" .. i]
			local btnY = self["btnY" .. i]
			for k, v in pairs(self["btnPosData" .. i]) do
				self.fields[k]:setX(isCurRefineBuff and btnX + v[1] or v[1] + self.centerX)
				self.fields[k]:setY(isCurRefineBuff and btnY + v[2] or btnY + v[2] - 25)
			end
		else
			self.fields["line_" .. i]:setVisible(false)
			self.fields["text_buff_new" .. i]:setVisible(false)
			self.fields["text_value_new" .. i]:setVisible(false)
			self.fields["btn_replace" .. i]:setVisible(false)
			self.fields["Label_title" .. i]:setVisible(false)
			self.fields["text_lock" .. i]:setVisible(false)
		end
	end
	self.lastRandomBuffs = lastRandombuffs
	self.fields.Com_MC_Have:setIcon(publicRead.getIcon(self.itemId))
	local itemCount = backpackCtrl:getItemCount(self.itemId)
	self.fields.Com_MC_Have:setTitle(itemCount)
	self.itemCount = itemCount
end
function DivineBeastMarkRefinePanel:onChooseClick(sender, index)
	SoraDPlaySound()
	if self.itemCount < self.cost then
		SoraDShowMsgTip(i18n("Divine_beast_mark_refinement_04"))
		return
	end
	divineBeastMarkCtrl:sendRefineRandomBuff(self.mark.bagMarkId, index)
end
function DivineBeastMarkRefinePanel:onDetailClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).mark = self.mark
	;(nil).isOnlyMaxLv = true
	uiManager:show("DivineBeastMarkRecount", nil)
end
function DivineBeastMarkRefinePanel:onModifyClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).mark = self.mark
	uiManager:show("DivineBeastMarkModifyChoose", nil)
end
function DivineBeastMarkRefinePanel:onReplaceClick(sender, index)
	SoraDPlaySound()
	divineBeastMarkCtrl:sendRefineRandomBuffAccept(self.mark.bagMarkId, index)
end
return DivineBeastMarkRefinePanel
