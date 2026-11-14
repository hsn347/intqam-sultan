local gametop = gModuleMgr.getObject("gametop")
local activity_9001573_Read = include("activity_9001573_Read")
local worldMapNebulaDefenceLod = class("worldMapNebulaDefenceLod", include("worldMapInstanceLod"))
function worldMapNebulaDefenceLod:ctor()
	worldMapNebulaDefenceLod.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapNebulaDefenceLod:_initData()
	self.isShowIcon = nil
end
function worldMapNebulaDefenceLod:_initUI()
	self.imgIcon = display.newSprite("#lod_monster.png")
	self.imgIcon:addTo(self, -1)
	self.imgIcon:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	self.node = display.newNode()
	self.node:setPositionY(-20)
	self.node:addTo(self, 1)
end
function worldMapNebulaDefenceLod:initInstanceData(objData, worldInstanceData, instanceData)
	local classID = worldInstanceData.class
	self.classID = classID
	self:updateData(objData)
	self:updateLodChange()
end
function worldMapNebulaDefenceLod:updateData(data)
	if not data then
		return
	end
end
local lodIcon = worldMapDefine.worldLodDef.LOD5
function worldMapNebulaDefenceLod:updateLodChange()
	local isShowIcon = self.lod >= lodIcon
	if isShowIcon ~= self.isShowIcon then
		self.isShowIcon = isShowIcon
		self:updateImage()
		if self.isShowIcon then
			self.node:setPositionY(-20)
		else
			self.node:setPositionY(-40)
		end
	end
end
function worldMapNebulaDefenceLod:updateImage()
	local imgName
	dump(self.classID, "self.classID")
	if self.isShowIcon then
		imgName = activity_9001573_Read.getBuildLodIcon(self.classID)
	else
		imgName = activity_9001573_Read.getBuildLodImg(self.classID)
	end
	dump(imgName, "imgName")
	if imgName and imgName ~= "" then
		self.imgIcon:setVisible(true)
		self.imgIcon:setSpriteFrame(imgName)
	else
		self.imgIcon:setVisible(false)
	end
end
return worldMapNebulaDefenceLod
