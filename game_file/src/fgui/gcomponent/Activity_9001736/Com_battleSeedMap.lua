local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local activity_9001736_Read = include("activity_9001736_Read")
local manorFarmRead = include("manorFarmRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_battleSeedMap = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_battleSeedMap", Com_battleSeedMap)
function Com_battleSeedMap:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_SELECT_SEED", handler(self, self.onMsgUpdateSeedInfo))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_UP_LEVEL", handler(self, self.onMsgUpdateSeedInfo))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_RESET_LEVEL", handler(self, self.onMsgUpdateSeedInfo))
end
function Com_battleSeedMap:onInit()
	self.seedObjList, activity_9001736_Ctrl = nil, nil
	self.seedPosTypeList = activity_9001736_Ctrl:getSeedPosTypeList()
	self.powerReducePer = activity_9001736_Ctrl:getSeedPowerReducePer()
	self.seedMaxNum = activity_9001736_Ctrl:getSeedMaxNum()
	for i = 1, self.seedMaxNum do
		local seedObj = self.fields[string.format("Com_battleSeed%02d", i)]
		seedObj:addClickListener(handlerEx(self, self.onClick_Button_seed, i))
		table.insert(self.seedObjList, seedObj)
		if not SoraDFIsRA() then
			seedObj:fixPos()
			seedObj:fixChildrenPos()
		end
	end
end
function Com_battleSeedMap:onShow()
	self:updateSeedIdList()
	for i, seedObj in ipairs(self.seedObjList) do
		seedObj:setSelected(false)
	end
end
function Com_battleSeedMap:onClick_Button_seed(idx, context)
	SoraDPlaySound()
	for i, seedObj in ipairs(self.seedObjList) do
		if i ~= idx then
			seedObj:setSelected(false)
		end
	end
	if self.selectCallback then
		self.selectCallback(idx)
	end
end
function Com_battleSeedMap:updateSeedIdList()
	self.seedIdList = activity_9001736_Ctrl:getBattleSeedList()
	for idx = 1, self.seedMaxNum do
		self:updateComSeed(idx)
	end
end
function Com_battleSeedMap:updateComSeed(idx)
	local seedObj = self.seedObjList[idx]
	local _fields = fguiHelper.get_fields(seedObj)
	local seedId = self.seedIdList[idx] or 0
	local imageName = activity_9001736_Read.getSeedImage(seedId)
	_fields.icon:setURL(imageName)
	local seedType = activity_9001736_Read.getSeedType(seedId)
	local imageName = manorFarmRead.getSeedTypeIcon(seedType)
	_fields.Image_camp:setURL(imageName)
	local posType = activity_9001736_Read.getSeedPosition(seedId)
	local targetPosType = self.seedPosTypeList[idx]
	if posType ~= targetPosType then
		_fields.Image_down:setVisible(true)
	else
		_fields.Image_down:setVisible(false)
	end
	local seedPower = activity_9001736_Ctrl:calculateSeedPower(seedId, targetPosType)
	local powerStr = string.formatnumberthousands(seedPower)
	_fields.Text_power:setString(powerStr)
end
function Com_battleSeedMap:onMsgUpdateSeedInfo()
	self:updateSeedIdList()
end
function Com_battleSeedMap:setSelectedIdx(idx)
	local seedObj = self.seedObjList[idx]
	if seedObj then
		seedObj:setSelected(true)
	end
end
function Com_battleSeedMap:setSelectCallback(callback)
	self.selectCallback = callback
end
return Com_battleSeedMap
