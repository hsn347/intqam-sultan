local buffCtrl = SoraDGetCtrl("buffCtrl")
local legendKingRead = include("legendKingRead")
local hegemonRead = include("hegemonRead")
local itemDesRead = include("itemDesRead")
local cityEffectInfoRead = include("cityEffectInfoRead")
local buffDesRead = include("buffDesRead")
local lordOfficialRead = include("lordOfficialRead")
local nebulaEmperorRead = include("nebulaEmperorRead")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local citybuffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CityInfoView/citybuffSingle", citybuffSingle)
function citybuffSingle:onInit()
	self.clickFun = nil
	self.fields.Text_newPlayer:setString(i18n("history_name_11"))
	self.fields.Text_newPlayer:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and 90 or -90)
	self.fields.bar:setScale(SoraDFIsRA() and -1 or 1)
end
function citybuffSingle:onShow()
end
function citybuffSingle:initData(data)
	self.data = data
	self.fields.Text_newPlayer:setVisible(false)
	if self.data.type == 0 then
		local buffData = buffCtrl:queryCityBuff(self.data.buffid)
		self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(cityEffectInfoRead.getQuaitly(self.data.buffid)))
		self.fields.Image_head:setSpriteFrame(cityEffectInfoRead.getIcon(self.data.buffid))
		self.fields.Text_name:setString(cityEffectInfoRead.getName(self.data.buffid))
		if self.data.buffid == gBuffEffect.MASSACRE and worldMapDefine.isInPyramid() then
			self.fields.Text_name:setString(cityEffectInfoRead.getName(self.data.buffid) .. fguiHelper.getColorString("#FF0000", i18n("common_text_4707")))
		end
		self.fields.Text_des:setString(cityEffectInfoRead.getDes(self.data.buffid))
		if buffData then
			self.controllers.c1:setSelectedIndex(1)
			self:setBarInfo(buffData)
		else
			self.controllers.c1:setSelectedIndex(0)
		end
		self.fields.arrow:setVisible(true)
		function self.clickFun()
			self = nil
			;(nil).bid = self.data.buffid
			;(nil).buffname = cityEffectInfoRead.getName(self.data.buffid)
			;(nil).bufdes = cityEffectInfoRead.getDes(self.data.buffid)
			;(nil).buftip = cityEffectInfoRead.getTip(self.data.buffid)
			;(nil).clashType = cityEffectInfoRead.getClashType(self.data.buffid)
			;(nil).icon = cityEffectInfoRead.getIcon(self.data.buffid)
			local (nil).quaitly, tableBuff = cityEffectInfoRead.getQuaitly(self.data.buffid), nil
			self = nil
			;(nil).tableBuff = tableBuff
			uiManager:show("citybuffItemView", nil)
		end
	elseif self.data.type == 1 then
		self:initLegendPersonalOfficial(self.data.officialID, self.data.mapid)
	elseif self.data.type == 2 then
		self:initHegemonOfficial(self.data.officialID)
	elseif self.data.type == 3 then
		self:initLegendWorldOfficial(self.data.officialID, self.data.mapid)
	elseif self.data.type == 4 then
		self:initNebulaEmperorOfficial(self.data.officialID)
	elseif self.data.type == 5 then
		self:initKingBattleData()
	elseif self.data.type == 6 then
		self:initIntetiorTrickData(self.data.skill)
	elseif self.data.type == 7 then
		self:initHalloweenData(self.data.itemID)
	elseif self.data.type == 8 then
		self:initAttackMonsterData(self.data.itemID)
	elseif self.data.type == 9 then
		self:initNewPlayerBuffData(self.data.buffID)
	elseif self.data.type == 10 then
		self:initLegendMBuffData(self.data.data)
	elseif self.data.type == 11 then
		self:initAtlantisOutWarBuff(self.data.data)
	elseif self.data.type == 12 then
		self:initAtlantisMapBuff(self.data.data)
	elseif self.data.type == 13 then
		self:initAtlantisInWarBuff(self.data.data)
	elseif self.data.type == 14 then
		self:initRechargeBuff(self.data.data)
	elseif self.data.type == 15 then
		self:initRoaringFlameOutWarBuff(self.data.data)
	end
end
function citybuffSingle:initRechargeBuff(data)
	local rechargeRead = include("rechargeRead")
	local cfg = rechargeRead.getBuffCfg(data.buffID)
	if cfg then
		self.fields.Image_head:setSpriteFrame(cfg.buffIcon)
		self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(gQualityDef.ORANGE))
		self.fields.Text_name:setString(i18n(cfg.buffName))
		self.fields.Text_des:setString(i18n(cfg.buffDes))
	end
	self:initRechargeBuffBar(data)
	self.fields.arrow:setVisible(false)
	self.clickFun = nil
end
function citybuffSingle:initAtlantisInWarBuff(data)
	local effect = data.effect
	local addCount = data.addCount
	local config = atlantisActivityCtrl:getBuffConfig(effect, data.src)
	self.fields.Image_head:setSpriteFrame(config.icon)
	atlantisActivityCtrl = self.fields.Image_head.setSpriteFrame
	self.fields.Image_head.setSpriteFrame[1] = 2
	self.fields.Image_head.setSpriteFrame[2] = 3
	local self.fields.Image_head.setSpriteFrame[3], quality2Lv = 5, self.fields.Image_head.setSpriteFrame
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(quality2Lv[config.itemquality]))
	self:initAtlantisInWarBuffBar(data)
	if addCount then
		self.fields.Text_name:setString(i18n(config.name) .. "x" .. addCount)
		local describe = config.describe2
		if not describe or not next(describe) then
			describe = config.describe
		end
		atlantisActivityCtrl = itemDesRead.getBgByLv(quality2Lv[config.itemquality])
		itemDesRead.getBgByLv(quality2Lv[config.itemquality]).var = data.value / 10
		self.fields.Text_des:setString(i18n(describe[1], itemDesRead.getBgByLv(quality2Lv[config.itemquality])))
	else
		self.fields.Text_name:setString(i18n(config.name))
		local describe = config.describe
		if not describe or not next(describe) then
			describe = config.describe2
		end
		self.fields.Text_des:setString(i18n(describe))
	end
	self.fields.arrow:setVisible(false)
	self.clickFun = nil
end
function citybuffSingle:initAtlantisMapBuff(data)
	local ASD = require_data("atlantiswar_skill_display").data
	local skillId = data.skillId
	self.fields.Image_head:setSpriteFrame(ASD[skillId].img)
	_ENV = self.fields.Image_head.setSpriteFrame
	self.fields.Image_head.setSpriteFrame[1] = 2
	self.fields.Image_head.setSpriteFrame[2] = 3
	local self.fields.Image_head.setSpriteFrame[3], quality2Lv = 5, self.fields.Image_head.setSpriteFrame
	local quality = ASD[skillId].quality
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(quality2Lv[quality]))
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Text_name:setString(i18n(ASD[skillId].name))
	local msg = atlantisActivityCtrl:getMapBuffDescribe(data.buffId, data.plus)
	msg = msg .. "\n" .. i18n("atlantiswar_text_0418")
	self.fields.Text_des:setString(msg)
	self.fields.arrow:setVisible(false)
	self.clickFun = nil
end
function citybuffSingle:initAtlantisOutWarBuff(data)
	local ASD = require_data("atlantiswar_skill_display").data
	local skillId = data.skillId
	self.fields.Image_head:setSpriteFrame(ASD[skillId].img)
	_ENV = self.fields.Image_head.setSpriteFrame
	self.fields.Image_head.setSpriteFrame[1] = 2
	self.fields.Image_head.setSpriteFrame[2] = 3
	local self.fields.Image_head.setSpriteFrame[3], quality2Lv = 5, self.fields.Image_head.setSpriteFrame
	local quality = ASD[skillId].quality
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(quality2Lv[quality]))
	self:initAtlantisOutWarBuffBar(data)
	self.fields.Text_name:setString(i18n(ASD[skillId].name))
	self.fields.Text_des:setString(i18n(ASD[skillId].describe))
	self.fields.arrow:setVisible(false)
	self.clickFun = nil
end
function citybuffSingle:initLegendMBuffData(data)
	local buffType = buffltCtrl:getEffectType(data.buffID)
	self.fields.Image_head:setSpriteFrame(cityEffectInfoRead.getIcon(buffType, 2, data.buffID))
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(cityEffectInfoRead.getQuaitly(buffType, 2, data.buffID)))
	self.fields.Text_newPlayer:setVisible(true)
	self:initLegendMData(data)
	self.fields.Text_int:setVisible(false)
	self.fields.Text_name:setString(cityEffectInfoRead.getName(buffType, 2, data.buffID))
	self.fields.Text_des:setString(cityEffectInfoRead.getDes(buffType, 2, data.buffID))
	self.fields.arrow:setVisible(false)
	self.clickFun = nil
end
function citybuffSingle:initAttackMonsterData(itemID)
	self.fields.Text_name:setString(i18n("common_text_2734"))
	self.fields.Image_head:setSpriteFrame("icon_buff_8202.png")
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(gQualityDef.ORANGE))
	local buffID = backpackltCtrl:getResult(itemID)
	local buffEffect = buffltCtrl:getEffectType(buffID)
	local buffData = buffCtrl:queryCityBuff(buffEffect)
	if buffData then
		self.controllers.c1:setSelectedIndex(1)
		self:setBarInfo(buffData)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.Text_des:setString(i18n("common_text_2734"))
	_ENV = self.fields.Text_des.setString
	self.fields.Text_des.setString.bid = buffEffect
	self.fields.Text_des.setString.buffname = i18n("common_text_2734")
	self.fields.Text_des.setString.bufdes = itemDesRead.getDes(itemID)
	self.fields.Text_des.setString.buftip = i18n("common_text_2734")
	self.fields.Text_des.setString.icon = itemDesRead.getIcon(itemID)
	self.fields.Text_des.setString.quaitly = itemDesRead.getQuality(itemID)
	local self.fields.Text_des.setString.itemID, tableBuff = itemID, self.fields.Text_des.setString
	self.fields.arrow:setVisible(true)
	function self.clickFun(...)
		_ENV = nil
		;(nil).tableBuff = tableBuff
		uiManager:show("citybuffItemView", nil)
	end
end
function citybuffSingle:initHalloweenData(itemID)
	self.fields.Text_name:setString(itemDesRead.getName(itemID))
	self.fields.Image_head:setSpriteFrame(itemDesRead.getIcon(itemID))
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBg(itemID))
	local buffID = backpackltCtrl:getResult(itemID)
	local buffEffect = buffltCtrl:getEffectType(buffID)
	local buffData = buffCtrl:queryHalloweenBuff(buffEffect)
	if buffData then
		self.controllers.c1:setSelectedIndex(1)
		self:setBarInfo(buffData)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.Text_des:setString(i18n("item_interface_text_" .. itemID))
	itemDesRead = self.fields.Text_des.setString
	self.fields.Text_des.setString.bid = buffEffect
	self.fields.Text_des.setString.buffname = itemDesRead.getName(itemID)
	self.fields.Text_des.setString.bufdes = i18n("item_interface_text_" .. itemID)
	self.fields.Text_des.setString.buftip = i18n("item_interface_notice_" .. itemID)
	self.fields.Text_des.setString.icon = itemDesRead.getIcon(itemID)
	self.fields.Text_des.setString.quaitly = itemDesRead.getQuality(itemID)
	local self.fields.Text_des.setString.itemID, tableBuff = itemID, self.fields.Text_des.setString
	self.fields.arrow:setVisible(true)
	function self.clickFun(...)
		local panel = SoraDCreatePanel("citybuffHalloweenItemView")
		panel:initData(tableBuff)
		panel:show()
	end
end
function citybuffSingle:initIntetiorTrickData(skill)
	self.fields.Text_name:setString(skill:getSkillName())
	self.fields.Image_head:setSpriteFrame(skill:getSkillIcon())
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(gQualityDef.ORANGE))
	self:initTrickData(skill)
	self.fields.Text_des:setString(skill:getSkillBuffDes())
	self.fields.arrow:setVisible(false)
	self.clickFun = nil
end
function citybuffSingle:initKingBattleData(...)
	self.fields.Text_name:setString(i18n("common_text_3036"))
	self.fields.Image_head:setSpriteFrame("icon_conquestwar_buff_01.png")
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(gQualityDef.GOLD))
	self:setBarKingbattleInfo()
	self.fields.Text_des:setString(i18n("common_text_3037"))
	self.fields.arrow:setVisible(true)
	function self.clickFun(...)
		local panel = SoraDCreatePanel("citybuffDesView")
		panel:initKingBattleData()
		panel:show()
	end
end
function citybuffSingle:initNebulaEmperorOfficial(officialID)
	local officerName = lordOfficialRead.getOfficialName(gShowOfficialType.NEBULA_EMPEROR, officialID)
	self.fields.Text_name:setString(officerName)
	local officerIcon = lordOfficialRead.getOfficialIcon(gShowOfficialType.NEBULA_EMPEROR, officialID)
	self.fields.Image_head:setSpriteFrame(officerIcon)
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(gQualityDef.GOLD))
	self.controllers.c1:setSelectedIndex(0)
	local officerType = nebulaEmperorRead.getOfficerType(officialID)
	if officerType == gLegendBuffType.KINGDOM then
		self.fields.Text_des:setString(i18n("nebulaemperor_text_154"))
	else
		self.fields.Text_des:setString(i18n("nebulaemperor_text_153"))
	end
	self.fields.arrow:setVisible(true)
	function self.clickFun(...)
		local panel = SoraDCreatePanel("legendaryKingBuff")
		panel:initNebulaEmperorOfficial(officialID)
		panel:show()
	end
end
function citybuffSingle:initLegendWorldOfficial(officialID, mapid)
	local officialInfo = legendKingRead.getOfficialInfo(gLegendBuffType.KINGDOM, officialID, mapid)
	if officialInfo then
		if officialInfo.name then
			self.fields.Text_name:setString(i18n(officialInfo.name))
		end
		if officialInfo.img then
			self.fields.Image_head:setSpriteFrame(officialInfo.img)
		end
	end
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(gQualityDef.GOLD))
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Text_des:setString(worldMapDefine.isKingStarMapId(mapid) and i18n("kingstarbattle_text_69") or i18n("legendaryking_text_05"))
	self.fields.arrow:setVisible(true)
	function self.clickFun(...)
		local panel = SoraDCreatePanel("legendaryKingBuff")
		panel:initLegendWorldOfficial(officialID, mapid)
		panel:show()
	end
end
function citybuffSingle:initLegendPersonalOfficial(officialID, mapid)
	local officialInfo = legendKingRead.getOfficialInfo(gLegendBuffType.PLAYER, officialID, mapid)
	if officialInfo then
		if officialInfo.name then
			self.fields.Text_name:setString(i18n(officialInfo.name))
		end
		if officialInfo.img then
			self.fields.Image_head:setSpriteFrame(officialInfo.img)
		end
	end
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(gQualityDef.GOLD))
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Text_des:setString(worldMapDefine.isKingStarMapId(mapid) and i18n("kingstarbattle_text_68") or i18n("legendaryking_text_04"))
	self.fields.arrow:setVisible(true)
	function self.clickFun(...)
		local panel = SoraDCreatePanel("legendaryKingBuff")
		panel:initLegendPersonalOfficial(officialID, mapid)
		panel:show()
	end
end
function citybuffSingle:initHegemonOfficial(officialID)
	local officialInfo = hegemonRead.getOfficialInfo(officialID)
	if officialInfo then
		local name = hegemonRead.getOfficialName(officialID)
		if name then
			self.fields.Text_name:setString(i18n("hegemon_title_20"))
		end
		local img = hegemonRead.getOfficialIcon(officialID)
		if img then
			self.fields.Image_head:setSpriteFrame(img)
		end
	end
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(gQualityDef.GOLD))
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Text_des:setString(i18n("hegemon_text_25"))
	self.fields.arrow:setVisible(true)
	function self.clickFun(...)
		local panel = SoraDCreatePanel("legendaryKingBuff")
		panel:initHegemonOfficial(officialID)
		panel:show()
	end
end
function citybuffSingle:initNewPlayerBuffData(buffID)
	local buffType = buffltCtrl:getEffectType(buffID)
	local buffData = buffCtrl:queryNewPlayerBuff(buffType)
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(cityEffectInfoRead.getQuaitly(buffType, 1)))
	self.fields.Image_head:setSpriteFrame(cityEffectInfoRead.getIcon(buffType, 1))
	if buffData then
		self.controllers.c1:setSelectedIndex(1)
		self:setBarInfo(buffData)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.Text_name:setString(cityEffectInfoRead.getName(buffType, 1))
	self.fields.Text_des:setString(cityEffectInfoRead.getDes(buffType, 1))
	self.fields.arrow:setVisible(false)
	self.clickFun = nil
end
function citybuffSingle:setBarInfo(buffData)
	self.fields.bar:setMax(buffData:getProperty("time"))
	self.fields.Text_time:setTimeUpdateListener(function(time)
		if time <= 0 then
			self.controllers.c1:setSelectedIndex(0)
		end
		self.fields.bar:setValue(time)
		self = nil
		;(nil).time = SoraDConvertSecondToString(time)
		self.fields.Text_time:setString(i18n("common_text_421", nil))
	end)
	self.fields.Text_time:beginTime(buffData:getRemainTime())
	local id = buffData:getProperty("effectType")
	local value = buffData:getProperty("effect")
	if "boolean" == type(value) then
		self.fields.Text_int:setString(i18n("common_text_246"))
	elseif "number" == type(value) then
		_ENV = i18n("common_text_246")
		i18n("common_text_246").val = buffDesRead.getTitleValueWithValue(id, value)
		self.fields.Text_int:setString(i18n("common_text_2837", i18n("common_text_246")))
	end
end
function citybuffSingle:setBarKingbattleInfo()
	self.fields.bar:setMax(CONQUESTWAR_WIN_BUFF_LASTTIME)
	local leftTime = conquestWarCtrl:getConquestWarWinBuffLefttime()
	self.fields.Text_int:setString(i18n("common_text_246"))
	self.fields.Text_time:setTimeUpdateListener(function(time)
		if time <= 0 then
			self.controllers.c1:setSelectedIndex(0)
		end
		self.fields.bar:setValue(time)
		self = nil
		;(nil).time = SoraDConvertSecondToString(time)
		self.fields.Text_time:setString(i18n("common_text_421", nil))
	end)
	if 0 < leftTime then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_time:beginTime(leftTime)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function citybuffSingle:initTrickData(skill)
	self.fields.bar:setMax(CONQUESTWAR_WIN_BUFF_LASTTIME)
	local leftTime = skill:getSkillEffectTime()
	self.fields.Text_int:setString(i18n("common_text_246"))
	self.fields.Text_time:setTimeUpdateListener(function(time)
		if time <= 0 then
			self.controllers.c1:setSelectedIndex(0)
		end
		self.fields.bar:setValue(time)
		self = nil
		;(nil).time = SoraDConvertSecondToString(time)
		self.fields.Text_time:setString(i18n("common_text_421", nil))
	end)
	if 0 < leftTime then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_time:beginTime(leftTime)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function citybuffSingle:initLegendMData(buffData)
	local leftTime = buffData.finishTime - serviceFunctions.systemTime()
	local totalTime = buffData.totalTime
	self.fields.bar:setMax(totalTime)
	self.fields.Text_time:setTimeUpdateListener(function(time)
		if time <= 0 then
			self.controllers.c1:setSelectedIndex(0)
		end
		self.fields.bar:setValue(time)
		self = nil
		;(nil).time = SoraDConvertSecondToString(time)
		self.fields.Text_time:setString(i18n("common_text_421", nil))
	end)
	if 0 < leftTime then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_time:beginTime(leftTime)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function citybuffSingle:initAtlantisOutWarBuffBar(buffData)
	local skillConfig = atlantisActivityCtrl:getSkillConfig(buffData.skillId)
	local totalTime = skillConfig.time
	local leftTime = buffData.time + totalTime - serviceFunctions.systemTime()
	self.fields.bar:setMax(totalTime)
	self.fields.Text_time:setTimeUpdateListener(function(time)
		if time <= 0 then
			self.controllers.c1:setSelectedIndex(0)
		end
		self.fields.bar:setValue(time)
		self = nil
		;(nil).time = SoraDConvertSecondToString(time)
		self.fields.Text_time:setString(i18n("common_text_421", nil))
	end)
	if 0 < leftTime then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_time:beginTime(leftTime)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	local count = skillConfig.count
	local remainCount = math.max(0, count - buffData.useCount)
	if 0 < remainCount then
		atlantisActivityCtrl = nil
		;(nil).count = remainCount
		self.fields.Text_int:setString(i18n("common_text_1673", nil))
	end
	self.fields.Text_int:setVisible(0 < remainCount)
end
function citybuffSingle:initAtlantisInWarBuffBar(buffData)
	local endTime = buffData.endTime
	local totalTime = endTime - buffData.beginTime
	local leftTime = endTime - serviceFunctions.systemTime()
	self.fields.bar:setMax(totalTime)
	self.fields.Text_int:setVisible(false)
	self.fields.Text_time:setTimeUpdateListener(function(time)
		if time <= 0 then
			self.controllers.c1:setSelectedIndex(0)
		end
		self.fields.bar:setValue(time)
		self = nil
		;(nil).time = SoraDConvertSecondToString(time)
		self.fields.Text_time:setString(i18n("common_text_421", nil))
	end)
	if 0 < leftTime then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_time:beginTime(leftTime)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function citybuffSingle:initRechargeBuffBar(buffData)
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local buffDesRead = include("buffDesRead")
	local rechargeRead = include("rechargeRead")
	local leftTime = buffData.endTime - serviceFunctions.systemTime()
	local totalTime = buffltCtrl:getTime(buffData.buffID) or 0
	self.fields.bar:setMax(totalTime)
	if totalTime == 0 then
		self.fields.Text_time:setString(i18n("common_text_4497"))
		self.fields.bar:setValue(totalTime)
	else
		self.fields.Text_time:setTimeUpdateListener(function(time)
			if time <= 0 then
				self.controllers.c1:setSelectedIndex(0)
			end
			self.fields.bar:setValue(time)
			self = nil
			;(nil).time = SoraDConvertSecondToString(time)
			self.fields.Text_time:setString(i18n("common_text_421", nil))
		end)
		self.fields.Text_time:setTimeEndListener(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART"
			SoraDSendMessage(nil)
		end)
		if 0 < leftTime then
			self.controllers.c1:setSelectedIndex(1)
			self.fields.Text_time:beginTime(leftTime)
		else
			self.controllers.c1:setSelectedIndex(0)
		end
	end
	local buffCfg = rechargeRead.getBuffCfg(buffData.buffID)
	local isActive = false
	if buffCfg then
		if buffCfg.castleLv[1] == 1 then
			isActive = SoraDGetCastleLv() >= buffCfg.castleLv[2] and SoraDGetCastleLv() <= buffCfg.castleLv[3]
		elseif buffCfg.castleLv[1] == 2 then
			isActive = SoraDGetBuildStarLv() >= buffCfg.castleLv[2] and SoraDGetBuildStarLv() <= buffCfg.castleLv[3]
		elseif buffCfg.castleLv[1] == 3 then
			local quality, lv, starLv = SoraDGetBuildQuality()
			isActive = lv >= buffCfg.castleLv[2] and lv <= buffCfg.castleLv[3]
		elseif buffCfg.castleLv[1] == 4 then
			local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
			local jinn1Lv = magicLampCtrl:getJinnLv(gJinnType.JINN_ONE)
			isActive = jinn1Lv >= buffCfg.castleLv[2] and jinn1Lv <= buffCfg.castleLv[3]
		elseif buffCfg.castleLv[1] == 5 then
			local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
			local hatchLv = magicLampHatchCtrl:getHatchLv()
			isActive = hatchLv >= buffCfg.castleLv[2] and hatchLv <= buffCfg.castleLv[3]
		elseif buffCfg.castleLv[1] == 6 then
			local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
			local jinn2Lv = magicLampCtrl:getJinnLv(gJinnType.JINN_TWO)
			isActive = jinn2Lv >= buffCfg.castleLv[2] and jinn2Lv <= buffCfg.castleLv[3]
		end
	end
	self.fields.Text_int:setVisible(true)
	if isActive then
		local buffType = buffltCtrl:getEffectType(buffData.buffID)
		local buffValue, buffMode = buffltCtrl:getEffect(buffData.buffID)
		local str = buffDesRead.getTitleValueWithValue(buffType, buffValue)
		_ENV = i18n("common_text_4497")
		i18n("common_text_4497").val = str
		self.fields.Text_int:setString(i18n("common_text_2837", i18n("common_text_4497")))
	else
		self.fields.Text_int:setString(i18n("hero_text_07"))
	end
end
function citybuffSingle:initRoaringFlameOutWarBuff(data)
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local skillId = data.skillId
	local cfg = roaringFlameWarRead.getSkillDisplayConfig(skillId)
	self.fields.Image_head:setSpriteFrame(cfg.img)
	_ENV = self.fields.Image_head.setSpriteFrame
	self.fields.Image_head.setSpriteFrame[1] = 2
	self.fields.Image_head.setSpriteFrame[2] = 3
	local self.fields.Image_head.setSpriteFrame[3], quality2Lv = 5, self.fields.Image_head.setSpriteFrame
	local quality = cfg.quality
	self.fields.Image_itemBg:setSpriteFrame(itemDesRead.getBgByLv(quality2Lv[quality]))
	self.fields.Text_name:setString(i18n(cfg.name))
	self.fields.arrow:setVisible(false)
	self.clickFun = nil
	if data.isMapBuff then
		self.controllers.c1:setSelectedIndex(0)
		local msg = atlantisActivityCtrl:getMapBuffDescribe(data.buffId, data.plus)
		msg = msg .. "\n" .. i18n("atlantiswar_text_0418")
		self.fields.Text_des:setString(msg)
	else
		self:initRoaringFlameOutWarBuffBar(data)
		self.fields.Text_des:setString(i18n(cfg.describe))
	end
end
function citybuffSingle:initRoaringFlameOutWarBuffBar(buffData)
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local skillConfig = roaringFlameWarRead.getSkillConfig(buffData.skillId)
	local totalTime = skillConfig.time
	local leftTime = buffData.time + totalTime - serviceFunctions.systemTime()
	self.fields.bar:setMax(totalTime)
	self.fields.Text_time:setTimeUpdateListener(function(time)
		if time <= 0 then
			self.controllers.c1:setSelectedIndex(0)
		end
		self.fields.bar:setValue(time)
		self = nil
		;(nil).time = SoraDConvertSecondToString(time)
		self.fields.Text_time:setString(i18n("common_text_421", nil))
	end)
	if 0 < leftTime then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_time:beginTime(leftTime)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	local count = skillConfig.count
	local remainCount = math.max(0, count - buffData.useCount)
	if 0 < remainCount then
		_ENV = nil
		;(nil).count = remainCount
		self.fields.Text_int:setString(i18n("common_text_1673", nil))
	end
	self.fields.Text_int:setVisible(0 < remainCount)
end
function citybuffSingle:btnClick()
	SoraDPlaySound()
	if self.clickFun then
		self.clickFun()
	end
end
return citybuffSingle
