local legendKingRead = include("legendKingRead")
local hegemonRead = include("hegemonRead")
local lordOfficialRead = include("lordOfficialRead")
local legendaryKingBuff = class("legendaryKingBuff", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("legendaryKingBuff")
	end
	if type(target) == "string" then
		return SoraDCreateTouchPanel(target)
	end
	return target
end)
function legendaryKingBuff:ctor()
	self.frame_maintenance_L = SoraDGetChildByName(self, "frame_maintenance_L")
	self.frame_maintenance_R = SoraDGetChildByName(self, "frame_maintenance_R")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.text_title = SoraDGetChildByName(self, "Text_title")
	self.Sprite_Official_Bg = SoraDGetChildByName(self, "Sprite_Official_Bg")
	self.Sprite_Official_Icon = SoraDGetChildByName(self, "Sprite_Official_Icon")
	self.Node_jiacheng_1 = SoraDGetChildByName(self, "Node_jiacheng_1")
	self.bg_jiacheng_1 = SoraDGetChildByName(self, "bg_jiacheng_1")
	self.text_jiacheng_1 = SoraDGetChildByName(self, "text_jiacheng_1")
	self.Node_jiacheng_2 = SoraDGetChildByName(self, "Node_jiacheng_2")
	self.bg_jiacheng_2 = SoraDGetChildByName(self, "bg_jiacheng_2")
	self.text_jiacheng_2 = SoraDGetChildByName(self, "text_jiacheng_2")
	self.Node_jiacheng_3 = SoraDGetChildByName(self, "Node_jiacheng_3")
	self.bg_jiacheng_3 = SoraDGetChildByName(self, "bg_jiacheng_3")
	_UPVALUE3_, self.text_jiacheng_3 = SoraDGetChildByName(self, "text_jiacheng_3"), SoraDGetChildByName(self, "text_jiacheng_3")
	_UPVALUE3_, self.buffNodes, SoraDGetChildByName(self, "text_jiacheng_3")[1] = SoraDGetChildByName(self, "text_jiacheng_3"), SoraDGetChildByName(self, "text_jiacheng_3"), self.Node_jiacheng_1
	_UPVALUE3_, self.buffNodes, SoraDGetChildByName(self, "text_jiacheng_3")[2] = SoraDGetChildByName(self, "text_jiacheng_3"), SoraDGetChildByName(self, "text_jiacheng_3"), self.Node_jiacheng_2
	_UPVALUE3_, self.buffNodes, SoraDGetChildByName(self, "text_jiacheng_3")[3] = SoraDGetChildByName(self, "text_jiacheng_3"), SoraDGetChildByName(self, "text_jiacheng_3"), self.Node_jiacheng_3
	self.textBuffNodes, SoraDGetChildByName(self, "text_jiacheng_3")[1] = SoraDGetChildByName(self, "text_jiacheng_3"), self.text_jiacheng_1
	self.textBuffNodes, SoraDGetChildByName(self, "text_jiacheng_3")[2] = SoraDGetChildByName(self, "text_jiacheng_3"), self.text_jiacheng_2
	self.textBuffNodes, SoraDGetChildByName(self, "text_jiacheng_3")[3] = SoraDGetChildByName(self, "text_jiacheng_3"), self.text_jiacheng_3
	self.classType = 1
	self.officialID = 0
	self.officialType = 0
end
function legendaryKingBuff:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR", handler(self, self.update))
end
function legendaryKingBuff:update(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
	local officialID
	if self.officialType == gShowOfficialType.LEGEND then
		if 1 == self.classType then
			officialID = legendLordCtrl:getLordTitleID(self.mapid)
		elseif 2 == self.classType then
			officialID = legendLordCtrl:getKingdomTitleID(self.mapid)
		end
	elseif self.officialType == gShowOfficialType.HEGEMON then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		officialID = hegemonCtrl:getLordTitleID()
	elseif self.officialType == gShowOfficialType.NEBULA_EMPEROR then
	end
	if not officialID or officialID ~= self.officialID then
		self:removeFromParent()
	end
end
function legendaryKingBuff:initHegemonOfficial(officialID)
	self:setDes("hegemon_text_25")
	self.classType = 3
	self.officialID = officialID
	self.officialType = gShowOfficialType.HEGEMON
	local officialInfo = hegemonRead.getOfficialInfo(officialID)
	if officialInfo then
		local name = hegemonRead.getOfficialName(officialID)
		if name then
			self.text_title:setString(i18n("hegemon_title_20"))
		end
		local img = hegemonRead.getOfficialIcon(officialID)
		if img then
			self.Sprite_Official_Icon:setSpriteFrame(img)
			if officialID == 1 then
				self.Sprite_Official_Icon:setScale(0.65)
			else
				self.Sprite_Official_Icon:setScale(1.3)
			end
			local isGood = hegemonRead.judgeIsGood(officialID)
			if isGood then
				self.Sprite_Official_Bg:setSpriteFrame("frame_touxiangkuang_01.png")
			else
				self.Sprite_Official_Bg:setSpriteFrame("frame_touxiangkuang_02.png")
			end
			self.Sprite_Official_Bg:setScale(1.3)
		end
		self:showHegemonBuffs(officialID)
	end
end
function legendaryKingBuff:showHegemonBuffs(buffId)
	for i = 1, #self.buffNodes do
		self.buffNodes[i]:setVisible(false)
		self.textBuffNodes[i]:setVisible(false)
	end
	local buffDesTb = hegemonRead.getBuffDesTbById(buffId)
	for i, v in ipairs(buffDesTb) do
		if self.buffNodes[i] then
			self.buffNodes[i]:setVisible(true)
		end
		if self.textBuffNodes[i] then
			self.textBuffNodes[i]:setVisible(true)
			self.textBuffNodes[i]:setString(v)
		end
	end
end
function legendaryKingBuff:initLegendPersonalOfficial(officialID, mapid)
	self.mapid = mapid
	self:setDes(worldMapDefine.isKingStarMapId(mapid) and "kingstarbattle_text_68" or "legendaryking_text_04")
	self:initLegendOfficial(2, officialID)
end
function legendaryKingBuff:initLegendWorldOfficial(officialID, mapid)
	self.mapid = mapid
	self:setDes(worldMapDefine.isKingStarMapId(mapid) and "kingstarbattle_text_69" or "legendaryking_text_05")
	self:initLegendOfficial(1, officialID)
end
function legendaryKingBuff:initLegendOfficial(classType, officialID)
	self.classType = classType
	self.officialID = officialID
	self.officialType = gShowOfficialType.LEGEND
	local officialInfo = legendKingRead.getOfficialInfo(classType, officialID, self.mapid)
	if officialInfo then
		if officialInfo.name then
			self.text_title:setString(i18n(officialInfo.name))
		end
		if officialInfo.img then
			self.Sprite_Official_Icon:setSpriteFrame(officialInfo.img)
		end
		self:showLegendBuffs(officialInfo.type)
	end
end
function legendaryKingBuff:showLegendBuffs(buffId)
	for i = 1, #self.buffNodes do
		self.buffNodes[i]:setVisible(false)
		self.textBuffNodes[i]:setVisible(false)
	end
	local _ENV, buffDesTb = (for index), 1
	if self.officialType == gShowOfficialType.NEBULA_EMPEROR then
		local nebulaEmperorRead = include("nebulaEmperorRead")
		buffDesTb = nebulaEmperorRead.getBuffDesTbById(buffId)
	else
		local buffType = self.classType
		buffDesTb = legendKingRead.getBuffDesTbById(buffType, buffId)
	end
	for i, v in ipairs(buffDesTb) do
		if self.buffNodes[i] then
			self.buffNodes[i]:setVisible(true)
		end
		if self.textBuffNodes[i] then
			self.textBuffNodes[i]:setVisible(true)
			self.textBuffNodes[i]:setString(v)
		end
	end
	self:reArrangeDes(#buffDesTb)
end
function legendaryKingBuff:setDes(key)
	self.Text_des:setString(i18n(key))
	local offsetX = self.Text_des:getContentSize().width * 0.5 + 60
	self.frame_maintenance_L:setPositionX(-offsetX)
	self.frame_maintenance_R:setPositionX(offsetX)
end
function legendaryKingBuff:reArrangeDes(num)
	local singleH = 62
	local centerY = 43
	local totalH = num * singleH
	local offsetY = -(totalH / 2 - centerY)
	for i = 1, num do
		self.buffNodes[i]:setPositionY((i - 1) * singleH + offsetY)
	end
end
function legendaryKingBuff:initNebulaEmperorOfficial(officialID)
	self.officialType = gShowOfficialType.NEBULA_EMPEROR
	local nebulaEmperorRead = include("nebulaEmperorRead")
	local officerType = nebulaEmperorRead.getOfficerType(officialID)
	if officerType == gLegendBuffType.KINGDOM then
		self:setDes("nebulaemperor_text_154")
	else
		self:setDes("nebulaemperor_text_153")
	end
	local officerName = lordOfficialRead.getOfficialName(self.officialType, officialID)
	self.text_title:setString(officerName)
	local officerIcon = lordOfficialRead.getOfficialIcon(self.officialType, officialID)
	self.Sprite_Official_Icon:setSpriteFrame(officerIcon)
	self:showLegendBuffs(officialID)
end
return legendaryKingBuff
