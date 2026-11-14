local baseComponent = require("fgui.base.baseComponent")
local Com_MC_MarkDetail = fgui.extension_class(fgui.GComponent, baseComponent)
local divineBeastMarkRead = include("divineBeastMarkRead")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local buffDesRead = include("buffDesRead")
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkDetail", Com_MC_MarkDetail)
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkDetail2", Com_MC_MarkDetail)
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkDetail3", Com_MC_MarkDetail)
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkDetail4", Com_MC_MarkDetail)
local colorGray = cc.c3b(116, 110, 101)
local colorGreen = cc.c3b(240, 230, 210)
function Com_MC_MarkDetail:onInit()
	if self.fields.Button_lock then
		self.fields.Button_lock:addClickEventListener(handler(self, self.onLockClick))
	end
	if self.fields.btn_tips then
		self.fields.btn_tips:addClickEventListener(handler(self, self.onShowRandomClick))
	end
	self.fields.Com_MC_Mark:forbidLongPress()
	self.activeColor = colorGreen
	self:fixChildrenPos()
end
function Com_MC_MarkDetail:onShow()
end
function Com_MC_MarkDetail:initData(mark, isShowNextLv)
	dump(isShowNextLv, "Com_MC_MarkDetail:initData")
	self.mark = mark
	self.isShowNextLv = isShowNextLv
	self.fields.Com_MC_Mark:initData(mark.markId)
	self.fields.Com_MC_Mark:getSetupItemUI():initData(mark.markCfg, mark.lv, mark.star, mark.randomElem)
	self.fields.Com_MC_Mark:getSetupItemUI():hideLv()
	if self.fields.element1 then
		self.fields.Com_MC_Mark:getSetupItemUI():hideElement()
	end
	self.isLock = self.mark.lock == 1
	if self.fields.Button_lock then
		self.fields.Button_lock:setIcon(self.isLock and "icon_lock_gold.png" or "icon_lock_unlock.png")
	end
	local markCfg = mark.markCfg
	local nextLvCfg = isShowNextLv and divineBeastMarkRead.getLvCfg(mark.markId, mark.lv + 1) or nil
	local lvCfg = self.mark.lvCfg
	local starCfg = divineBeastMarkRead.getStarCfg(mark.star)
	self.nextLvCfg = nextLvCfg
	if self.fields.btn_tips then
		self.fields.btn_tips:setIcon(markCfg.quality < 4 and "btn_detail.png" or "frame_ssyj_shuxing.png")
	end
	self.controllers.c1:setSelectedIndex(nextLvCfg == nil and 0 or 1)
	_ENV = nil
	;(nil).lv = mark.lv
	self.fields.lv_now:setString(i18n("common_text_100", nil))
	self.fields.txt_name:setString(i18n(markCfg.name))
	self.fields.txt_fc:setString(lvCfg.power + starCfg.power)
	self.fields.Com_MC_Stars:initData(mark.star)
	for i = 1, 7 do
		local obj = self.fields["element" .. i]
		if obj then
			local element = markCfg.elements[i]
			obj:setVisible(element ~= nil)
			if element ~= nil then
				element = element == 5 and self.mark.randomElem ~= 0 and self.mark.randomElem or element
				obj:setIcon(divineBeastMarkRead.getElementIcon(element))
				obj:setGrayed((markCfg.elements_lv[i] or 0) > mark.lv)
			end
		end
	end
	local _ENV, lastRandombuffs = (for index), 1
	for i = 1, 2 do
		local randomBuffLv = markCfg.randombuff_lv[i]
		local randomBuff = mark["randomBuff" .. i]
		local randomBuffCfg = mark["randomBuffCfg" .. i]
		lastRandombuffs[i] = randomBuff
		self.fields["text_buff" .. i]:setVisible(randomBuffLv ~= nil)
		self.fields["text_value" .. i]:setVisible(randomBuffLv ~= nil)
		self.fields["text_next_value" .. i]:setVisible(false)
		self.fields["arrow" .. i]:setVisible(false)
		if randomBuffLv then
			local buffStr = randomBuff == 0 and i18n("Divine_beast_mark_text_18") or buffDesRead.getTitleBase(randomBuff, false, true)
			if randomBuff == 0 then
				_ENV = true
				;(true).num = randomBuffLv
				if i18n("Divine_beast_mark_text_17", true) then
					goto lbl_268
				end
			end
			local valueStr = buffDesRead.getTitleValueWithValue(randomBuff, SoraDPreciseDecimal(randomBuffCfg.value[markCfg.randombuff_type] / 10, 2), false)
			::lbl_268::
			self.fields["text_buff" .. i]:setString(buffStr)
			self.fields["text_buff" .. i]:setColor(randomBuff == 0 and colorGray or self.activeColor)
			self.fields["text_value" .. i]:setString(valueStr)
			self.fields["text_value" .. i]:setColor(randomBuff == 0 and colorGray or self.activeColor)
			local nextRandomLvCfg = isShowNextLv and randomBuff ~= 0 and divineBeastMarkRead.getRandomEffect(randomBuff, markCfg.quality, mark.lv + 1) or nil
			self.fields["text_next_value" .. i]:setVisible(nextRandomLvCfg ~= nil)
			self.fields["arrow" .. i]:setVisible(nextRandomLvCfg ~= nil)
			if nextRandomLvCfg ~= nil then
				local nextValueStr = buffDesRead.getTitleValueWithValue(randomBuff, SoraDPreciseDecimal(nextRandomLvCfg.value[markCfg.randombuff_type] / 10, 2), false)
				self.fields["text_next_value" .. i]:setString(nextValueStr)
			end
			if self.lastBagMarkId == self.mark.bagMarkId and self.lastRandomBuffs ~= nil and self.lastRandomBuffs[i] == 0 and randomBuff ~= 0 and self.fields["Ani_buff" .. i] then
				self.fields["Ani_buff" .. i]:setVisible(true)
				self.fields["Ani_buff" .. i]:setAllFrameNameOnce("ssyj_effect_wzjs_%02d.png", 1, false)
			end
		end
	end
	self.lastBagMarkId = self.mark.bagMarkId
	self.lastRandomBuffs = lastRandombuffs
	local des1
	if not isShowNextLv or nextLvCfg == nil then
		des1 = i18n(lvCfg.introduce)
	else
		local arrowPng = SoraDFIsRA() and "#icon_ssyj_arrow1.png" or "#icon_ssyj_arrow2.png"
		_ENV = self.fields["element" .. i]
		self.fields["element" .. i].param = arrowPng
		self.fields["element" .. i].name = "arrow"
		self.fields["element" .. i].width = 18
		self.fields["element" .. i].height = 19
		self.fields["element" .. i].custom = "Sprite"
		self.fields["element" .. i].offsety = 1
		local arrowTag = SoraDWrapReplaceTag(self.fields["element" .. i])
		local nextLvColor = self.fields.lv_next:getColor()
		local introduce1 = lvCfg.introduce
		local introduce2 = nextLvCfg.introduce
		local _ENV, keyParams = mark["randomBuffCfg" .. i], mark["randomBuffCfg" .. i]
		local _ENV, style = buffDesRead.getTitleBase(randomBuff, false, true), buffDesRead.getTitleBase(randomBuff, false, true)
		for k, v in pairs(introduce1) do
			if k ~= 1 then
				_ENV = divineBeastMarkRead.getElementIcon(element)
				divineBeastMarkRead.getElementIcon(element).color = nextLvColor
				local value2 = SoraDWrapHtmlTagByStyle(introduce2[k], divineBeastMarkRead.getElementIcon(element))
				keyParams[k] = string.format("%s %s %s", v, arrowTag, value2)
			else
				keyParams[k] = v
			end
		end
		des1 = i18n_html(introduce1[1], keyParams)
	end
	self.fields.text_desc1:setString(des1)
	if nextLvCfg ~= nil then
		_ENV = nextLvCfg.introduce
		nextLvCfg.introduce.lv = mark.lv + 1
		self.fields.lv_next:setString(i18n("common_text_100", nextLvCfg.introduce))
	end
end
function Com_MC_MarkDetail:initDataByMarkId(markId)
	self.fields.Com_MC_Mark:initData(markId)
	self.fields.Com_MC_Mark:getSetupItemUI():hideSelf()
	local markCfg = divineBeastMarkRead.getDbMarkCfg(markId)
	local lvCfg = divineBeastMarkRead.getLvCfg(markId, 0)
	self.fields.txt_name:setString(i18n(markCfg.name))
	self.fields.txt_fc:setString(lvCfg.power)
	self.fields.Com_MC_Stars:initData(0)
	divineBeastMarkRead = i18n(markCfg.name)
	i18n(markCfg.name).lv = 0
	self.fields.lv_now:setString(i18n("common_text_100", i18n(markCfg.name)))
	self.fields.text_desc1:setString(i18n(lvCfg.introduce))
	for i = 1, 2 do
		local randomBuffLv = markCfg.randombuff_lv[i]
		self.fields["text_buff" .. i]:setVisible(randomBuffLv ~= nil)
		self.fields["text_value" .. i]:setVisible(randomBuffLv ~= nil)
		if randomBuffLv then
			local buffStr = i18n("Divine_beast_mark_text_18")
			divineBeastMarkRead = i18n(lvCfg.introduce)
			i18n(lvCfg.introduce).num = randomBuffLv
			local valueStr = i18n("Divine_beast_mark_text_17", i18n(lvCfg.introduce))
			self.fields["text_buff" .. i]:setString(buffStr)
			self.fields["text_buff" .. i]:setColor(colorGray)
			self.fields["text_value" .. i]:setString(valueStr)
			self.fields["text_value" .. i]:setColor(colorGray)
		end
	end
end
function Com_MC_MarkDetail:setLock(isLock)
	self.isLock = isLock
	self.fields.Button_lock:setSelectedIndex(isLock and 1 or 0)
end
function Com_MC_MarkDetail:setLockVisible(isVisible)
	if self.fields.Button_lock then
		self.fields.Button_lock:setVisible(isVisible)
	end
end
function Com_MC_MarkDetail:getUpgradeExp()
	return self.nextLvCfg and self.nextLvCfg.exp or 0
end
function Com_MC_MarkDetail:getNextLvNeedStar()
	return self.nextLvCfg and self.nextLvCfg.need_star or 0
end
function Com_MC_MarkDetail:updateMark(bagMarkId)
	if self.mark and (bagMarkId == nil or self.mark.bagMarkId == bagMarkId) then
		self.mark = divineBeastMarkCtrl:getMarkByBagMarkId(self.mark.bagMarkId)
		self:initData(self.mark, self.isShowNextLv)
	end
end
function Com_MC_MarkDetail:onLockClick()
	SoraDPlaySound()
	if self.isLock then
		SoraDCheckSecondaryLock(function()
			divineBeastMarkCtrl:sendLock(self.mark.bagMarkId, self.isLock and 0 or 1)
		end, gSecondaryLockType.BeastMarkUnlock, "DivineBeastMarkMain")
	else
		divineBeastMarkCtrl:sendLock(self.mark.bagMarkId, self.isLock and 0 or 1)
	end
end
function Com_MC_MarkDetail:onShowRandomClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).mark = self.mark
	uiManager:show("DivineBeastMarkRecount", nil)
end
function Com_MC_MarkDetail:setActiveColor(activeColor)
	self.activeColor = activeColor
end
return Com_MC_MarkDetail
