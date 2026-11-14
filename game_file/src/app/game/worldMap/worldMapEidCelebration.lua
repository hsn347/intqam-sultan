local worldMapEidCelebration = class("worldMapEidCelebration", function()
	local target = include("worldMapInstance").new("worldMapEidCelebration")
	return target
end)
function worldMapEidCelebration:ctor()
	self.ignoreRequest = true
	self:_initUI()
	self:_initData()
end
function worldMapEidCelebration:_initData()
end
function worldMapEidCelebration:_initUI()
	self.modelImage = display.newSprite("#Map_build_edial.png")
	self.modelImage:setPositionY(35)
	self:addChild(self.modelImage, -1)
	self.modelImage:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	self.image_name_bg = display.newSprite("#frame_nebulawars_namet.png")
	self.image_name_bg:setOpacity(204.0)
	self.image_name_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 30))
	self.image_name_bg:addTo(self, 1)
	self.image_name_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name_bg
	self.image_name_bg.UILabelType = 2
	self.image_name_bg.text = ""
	self.image_name_bg.size = 18
	self.text_Name = SoraDCreateLabel(self.image_name_bg)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setColor(cc.c3b(254, 241, 196))
	self.text_Name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 30))
	self.text_Name:addTo(self, 1)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.progressBar = SoraDCreatePanel("worldMapBossProgressBar")
	self.progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 60))
	self.progressBar:setAnchorPoint(cc.p(0.5, 0.5))
	self.progressBar:addTo(self, 1)
	self.progressBar:setGroupID(worldMapDefine.GROU_ID.group_progress_monster)
	self.progressBar:setGroupAuto(true)
	self.progressBar:setVisible(false)
end
function worldMapEidCelebration:initInstanceData(resourceClassID, data)
	self:updateData(data)
end
function worldMapEidCelebration:updateData(data)
	dump(data, "worldMapEidCelebration:updateData")
	self.data = data
	self.isSelf = self.data.placeUid == SoraDGetPlayerID()
	if not self.isSelf or not i18n("eidal_celebration_text23") then
		_ENV = nil
		;(nil).name = self.data.nickName
	end
	self.text_Name:setString((i18n("eidal_celebration_text24", nil)))
	self.text_Name:setColor(self.isSelf and cc.c3b(254, 241, 196) or cc.c3b(0, 185, 255))
	if self.isSelf and self.data.disappearTime and self.data.disappearTime > serviceFunctions.systemTime() then
		self.progressBar:setVisible(true)
		local cfg = include("activity_9001643_Read").getTaskCfg(self.data.taskID)
		self.progressBar:setTimeValue(self.data.disappearTime - serviceFunctions.systemTime(), cfg.times)
	else
		self.progressBar:setVisible(false)
	end
end
function worldMapEidCelebration:onClickInstance(onShowView)
	print("worldMapEidCelebration:onClickInstance")
	if self.isSelf then
		local panel = uiManager:show("Activity_9001643_Dispatch").view
		panel:initData(self.data)
		return panel, false
	end
end
return worldMapEidCelebration
