local AllianceSettingsListSingle = class("allianceSettingsListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceSettingsListSingle")
	end
	return target
end)
_ENV = "allianceSettingsListSingle"
;("allianceSettingsListSingle")[1] = "frame_alliance_message_06.png"
;("allianceSettingsListSingle")[2] = "frame_alliance_message_01.png"
;("allianceSettingsListSingle")[3] = "frame_alliance_message_05.png"
;("allianceSettingsListSingle")[4] = "frame_alliance_message_02.png"
;("allianceSettingsListSingle")[5] = "frame_alliance_message_03.png"
;("allianceSettingsListSingle")[6] = "frame_alliance_message_04.png"
local ("allianceSettingsListSingle")[7], spPNG = "img_lianmengguanli_ditu.png", "allianceSettingsListSingle"
function AllianceSettingsListSingle:ctor()
	self.isLaunched = false
	self.singleTag = 0
	self.childNode = nil
	self.handl = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.spriteBgD = SoraDGetChildByName(self, "Image_bgD")
	self.spriteBgD:setVisible(false)
	self.spriteSp = SoraDGetChildByName(self, "Image_sp")
	self.spriteArr = SoraDGetChildByName(self, "Sprite_arr")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.btnSingle = SoraDGetChildByName(self, "Button_single")
	if self.btnSingle then
		self.btnSingle:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.btnSingle:setSwallowTouches(false)
	end
end
function AllianceSettingsListSingle:initData(tag)
	self.singleTag = tag
	self:updateOtherUI()
end
function AllianceSettingsListSingle:updateOtherUI()
	local allianceDesRead = include("allianceDesRead")
	self.labelTitle:setString(allianceDesRead.getSettingsName(self.singleTag))
	self.spriteSp:loadTexture(spPNG[self.singleTag], ccui.TextureResType.plistType)
end
function AllianceSettingsListSingle:getSingleH()
	local singleH = self.btnSingle:getContentSize().height
	if self.childNode then
		singleH = singleH + self.childNode:getSingleH()
	end
	return singleH
end
function AllianceSettingsListSingle:updateBg()
	local singleH = self:getSingleH()
	self.spriteBgD:setVisible(not self.isLaunched)
	self.spriteBgD:setContentSize(cc.size(630, singleH))
end
function AllianceSettingsListSingle:setClickCallBack(handle)
	self.handl = handle
end
function AllianceSettingsListSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceSettingsListSingle:setState(state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeNode()
		self.spriteArr:setRotation(SoraDFPosX(90, 0))
	else
		self:initNode()
		self.spriteArr:setRotation(0)
	end
	self.isLaunched = state
end
function AllianceSettingsListSingle:initNode()
	if self.singleTag == gaSettings.SLOGAN then
		self.childNode = SoraDCreatePanel("changeSloganNode")
	elseif self.singleTag == gaSettings.RECRUITMENT then
		self.childNode = SoraDCreatePanel("changeOpenRecruitmentNode")
	elseif self.singleTag == gaSettings.NAME or self.singleTag == gaSettings.NICKNAME then
		self.childNode = SoraDCreatePanel("changeAllianceNicknameNode")
		self.childNode:initData(self.singleTag)
	elseif self.singleTag == gaSettings.LANGUAGE then
		self.childNode = SoraDCreatePanel("changeAllianceLanguageNode")
	elseif self.singleTag == gaSettings.RANK then
		self.childNode = SoraDCreatePanel("changeAllianceRankTitleNode")
	elseif self.singleTag == gaSettings.COLOR then
		self.childNode = SoraDCreatePanel("changeTerritoryColorNode")
	end
	if self.childNode then
		self.childNode:setPosition(cc.p(0, -self.btnSingle:getContentSize().height))
		self.childNode:addTo(self, 1)
	end
	self:updateBg()
end
function AllianceSettingsListSingle:removeNode()
	if self.childNode then
		self.childNode:removeFromParent()
		self.childNode = nil
	end
	self:updateBg()
end
function AllianceSettingsListSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.singleTag == gaSettings.COLOR then
			local allianceDesRead = include("allianceDesRead")
			if not allianceDesRead.checkRank(gAllianceRank.R5, true, i18n("alliance_landSet_002")) then
				return
			end
		end
		self:setState(not self.isLaunched)
		if self.handl then
			self.handl(self, self.singleTag, self.isLaunched)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return AllianceSettingsListSingle
