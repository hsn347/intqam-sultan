local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local CommonItems = class("commonItems", function(target)
	if target == nil then
		print("该类只用于控制")
	end
	return target
end)
function CommonItems:ctor()
	self.bg = SoraDGetChildByName(self, "Image_bg")
	self.item = SoraDGetChildByName(self, "Image_item")
	self.num = SoraDGetChildByName(self, "Text_num")
	self.imgNum = SoraDGetChildByName(self, "Image_num")
	self.name = SoraDGetChildByName(self, "Text_name")
	self.img_warpattern = SoraDGetChildByName(self, "img_warpattern")
	if self.img_warpattern then
		self.img_warpattern:setVisible(false)
	end
	self.bg:setVisible(false)
	self.item:setVisible(false)
end
function CommonItems:initData(itemData)
	if itemData == nil then
		self.bg:setVisible(false)
		self.item:setVisible(false)
		if self.name then
			self.name:setString("")
		end
		return
	end
	local itemDesRead = include("publicRead")
	self.bg:setVisible(true)
	self.item:setVisible(true)
	local bt = tolua.type(self.bg)
	local it = tolua.type(self.item)
	if not require("app." .. LocalTblPath .. ".config_server.equipment_with_quality_config.lua") then
		local _ENV, config = require("app." .. LocalTblPath .. ".config_server.equipment_with_quality_config.lua"), require("app." .. LocalTblPath .. ".config_server.equipment_with_quality_config.lua")
	end
	if bt == "cc.Sprite" then
		if config[itemData.itemID] then
			self.bg:setSpriteFrame(itemDesRead.getBgByQuality(config[itemData.itemID].quality))
		else
			self.bg:setSpriteFrame(itemDesRead.getBg(itemData.itemID))
		end
	elseif config[itemData.itemID] then
		self.bg:loadTexture(itemDesRead.getBgByQuality(config[itemData.itemID].quality), ccui.TextureResType.plistType)
	else
		self.bg:loadTexture(itemDesRead.getBg(itemData.itemID), ccui.TextureResType.plistType)
	end
	itemData.itemID = config[itemData.itemID] and config[itemData.itemID].equipmentID or itemData.itemID
	if it == "cc.Sprite" then
		if itemData.itemID == 1001 and itemData.isBig then
			self.item:setSpriteFrame("icon_recharge_gold_01.png")
		else
			self.item:setSpriteFrame(itemDesRead.getIcon(itemData.itemID))
		end
	elseif itemData.itemID == 851100 then
		self.item:loadTexture("1033_ros.png", ccui.TextureResType.plistType)
	else
		self.item:loadTexture(itemDesRead.getIcon(itemData.itemID), ccui.TextureResType.plistType)
	end
	if self.name then
		self.name:setString(itemDesRead.getName(itemData.itemID))
	end
	if self.num and itemData.itemCount ~= nil then
		self.num:setVisible(itemData.itemCount ~= 0)
		if self.imgNum then
			self.imgNum:setVisible(itemData.itemCount ~= 0)
		end
		self.num:setString(string.formatnumberthousands(itemData.itemCount))
	end
	if self.num and itemData.itemCount and itemData.maxCount then
		self.num:setString(string.format("%d/%d", itemData.itemCount, itemData.maxCount))
		if itemData.itemCount < itemData.maxCount then
			self.num:setColor(display.COLOR_RED)
		else
			self.num:setColor(display.COLOR_GREEN)
		end
	end
	if self.img_warpattern then
		local itemType = backpackltCtrl:getItemType(itemData.itemID)
		local idType = serviceFunctions.getIDType(itemData.itemID)
		self.img_warpattern:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(itemData.itemID)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.img_warpattern:setVisible(true)
					self.img_warpattern:setSpriteFrame(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(itemData.itemID)
			if subscript then
				self.img_warpattern:setVisible(true)
				self.img_warpattern:setSpriteFrame(subscript)
			end
		end
	end
end
function CommonItems:hiddleNum(isHiddle)
	if self.num then
		self.num:setVisible(not isHiddle)
	end
	if self.imgNum then
		self.imgNum:setVisible(not isHiddle)
	end
end
return CommonItems
