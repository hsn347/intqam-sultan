local MAX_ATTR_NUM = 3
local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatRuneBuffPopPanel = class("CheatRuneBuffPopPanel", baseFguiPanel)
function CheatRuneBuffPopPanel:ctor(...)
	self.isLRU = true
	CheatRuneBuffPopPanel.super.ctor(self, ...)
	print("CheatRuneBuffPopPanel:ctor", self.viewName)
end
function CheatRuneBuffPopPanel:onInit()
	print("=======CheatRuneBuffPopPanel:onInit")
	self.fields.Panel_bg:setString("战纹随机属性设置")
	self.fields.Text_attr:setString("属性组ID")
	self.fields.Text_range:setString("等级范围")
	self.fields.Text_input:setString("等级")
	self.fields.Button_ok:setString("确定")
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.Button_review:setString("预览BUFF")
	self.fields.Button_review:addClickListener(handler(self, self.btnReviewClick))
end
function CheatRuneBuffPopPanel:endShow()
	print("=======CheatRuneBuffPopPanel:endShow")
	self.index = self.param.index
	self.indexArray, _ENV, self.runeInfo = self.param.runeInfo, self.param.runeInfo, self.param.runeInfo
	for i = 1, MAX_ATTR_NUM do
		self.fields["input_" .. i]:getChild("input"):addEventListener(fgui.UIEventType.Submit, handlerEx(self, self.onSubmit, i))
		local groupID = self.runeInfo.extraProperty[i][1]
		self.indexArray[i] = groupID
		local toIndex = 0
		local runeCfg = artifactRuneRead.getRuneConfig(self.runeInfo.rid)
		local _ENV, items = self.runeInfo.rid, self.runeInfo.rid
		for k, poolID in ipairs(runeCfg.InitPool) do
			local poolCfg = artifactRuneRead.getRandomBuffCfg(poolID)
			artifactRuneRead = handlerEx(self, self.onSubmit, i)
			handlerEx(self, self.onSubmit, i)[1] = "id"
			handlerEx(self, self.onSubmit, i)[2] = "percent"
			local groupArray = serviceFunctions.tableFormat(poolCfg.PropertyPool, handlerEx(self, self.onSubmit, i))
			items, _ENV = poolCfg.PropertyPool, poolCfg.PropertyPool
			for index, v in ipairs(groupArray) do
				table.insert(items, v.id)
				if groupID == v.id then
					toIndex = index - 1
				end
			end
		end
		_ENV = "ComboBox_" .. i
		;("ComboBox_" .. i).items = items
		;("ComboBox_" .. i).values = items
		;("ComboBox_" .. i).changedCallback = handlerEx(self, self.onComboBoxClick, i)
		self:setComboBox(self.fields["ComboBox_" .. i], "ComboBox_" .. i)
		self.fields["ComboBox_" .. i]:setSelectedIndex(toIndex)
	end
	self:setBuffRange()
end
function CheatRuneBuffPopPanel:onSubmit(index)
	local _, _, _, _, PropertiesGrowingType = artifactRuneRead.getPropertyArray(self.indexArray[index])
	local maxAttrLv = artifactRuneRead.getAttrMaxLv(PropertiesGrowingType)
	local text = self.fields["input_" .. index]:getChild("input"):getText()
	local lv = tonumber(text)
	if not lv or maxAttrLv < lv then
		self.fields["input_" .. index]:getChild("input"):setText(maxAttrLv)
		SoraDShowMsgTip("输入等级错误！！")
	end
	self:setBuffShow()
end
function CheatRuneBuffPopPanel:onComboBoxClick(index)
	SoraDPlaySound()
	self.indexArray[index] = tonumber(self.fields["ComboBox_" .. index]:getValue())
	self:setBuffShow()
end
function CheatRuneBuffPopPanel:setBuffRange()
	for i = 1, MAX_ATTR_NUM do
		local _, _, _, _, PropertiesGrowingType = artifactRuneRead.getPropertyArray(self.indexArray[i])
		local maxAttrLv = artifactRuneRead.getAttrMaxLv(PropertiesGrowingType)
		self.fields["Text_range_" .. i]:setString("[1~" .. maxAttrLv .. "]")
		local attrLv = self.runeInfo.extraProperty[i] and self.runeInfo.extraProperty[i][2] or 0
		if attrLv == 0 then
			attrLv = maxAttrLv
		end
		self.fields["input_" .. i]:getChild("input"):setText(attrLv)
	end
	self:setBuffShow()
end
function CheatRuneBuffPopPanel:setBuffShow()
	local MAX_ATTR_NUM, buffMap
	for i = 1, MAX_ATTR_NUM do
		local propertyArray, quality = artifactRuneRead.getPropertyArray(self.indexArray[i])
		for k, v in ipairs(propertyArray) do
			local _, _, _, _, PropertiesGrowingType = artifactRuneRead.getPropertyArray(self.indexArray[i])
			local maxAttrLv = artifactRuneRead.getAttrMaxLv(PropertiesGrowingType)
			local inputLv = tonumber(self.fields["input_" .. i]:getChild("input"):getText()) or maxAttrLv
			local buffLv = math.min(inputLv, maxAttrLv)
			local pLvCfg = artifactRuneRead.getPropertiesLvCfg(v.growType, buffLv)
			if not buffMap[v.buffType] then
				MAX_ATTR_NUM = buffLv
				buffLv.buffVal = v.buffVal + pLvCfg.GrowingValue
				buffMap[v.buffType], buffLv.buffMode = buffLv, v.buffMode
			else
				buffMap[v.buffType].buffVal = buffMap[v.buffType].buffVal + v.buffVal + pLvCfg.GrowingValue
			end
		end
	end
	local MAX_ATTR_NUM, buffList = (for index), 1
	for buffType, cfg in pairs(buffMap) do
		MAX_ATTR_NUM = ipairs(propertyArray)
		ipairs(propertyArray).buffType = buffType
		ipairs(propertyArray).buffVal = cfg.buffVal
		ipairs(propertyArray).buffMode = cfg.buffMode
		table.insert(buffList, ipairs(propertyArray))
	end
	table.sort(buffList, function(a, b)
		return a.buffType < b.buffType
	end)
	local des = ""
	for k, v in ipairs(buffList) do
		if k == #buffList then
			des = des .. buffDesRead.getBuffDes(v.buffType, v.buffVal, v.buffMode)
		else
			des = des .. buffDesRead.getBuffDes(v.buffType, v.buffVal, v.buffMode) .. ","
		end
	end
	self.fields.Label_content:setString(des)
end
function CheatRuneBuffPopPanel:btnReviewClick()
	SoraDPlaySound()
	self:setBuffShow()
end
function CheatRuneBuffPopPanel:btnOkClick()
	SoraDPlaySound()
	local isRight = true
	for i = 1, MAX_ATTR_NUM do
		local _, _, _, _, PropertiesGrowingType = artifactRuneRead.getPropertyArray(self.indexArray[i])
		local maxAttrLv = artifactRuneRead.getAttrMaxLv(PropertiesGrowingType)
		local inputLv = tonumber(self.fields["input_" .. i]:getChild("input"):getText())
		if not inputLv or maxAttrLv < inputLv then
			self.fields["input_" .. i]:getChild("input"):setText(maxAttrLv)
			isRight = false
		end
	end
	if not isRight then
		SoraDShowMsgTip("输入等级错误！！")
		return
	end
	for i = 1, MAX_ATTR_NUM do
		_UPVALUE3_ = artifactRuneRead.getPropertyArray(self.indexArray[i])
		self.runeInfo.extraProperty[i], artifactRuneRead.getPropertyArray(self.indexArray[i])[1] = artifactRuneRead.getPropertyArray(self.indexArray[i])
		self.runeInfo.extraProperty[i], artifactRuneRead.getPropertyArray(self.indexArray[i])[2] = artifactRuneRead.getPropertyArray(self.indexArray[i])
		self.runeInfo.extraProperty[i], artifactRuneRead.getPropertyArray(self.indexArray[i])[3] = artifactRuneRead.getPropertyArray(self.indexArray[i])
	end
	_ENV = MAX_ATTR_NUM
	MAX_ATTR_NUM.msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_RUNE"
	MAX_ATTR_NUM.index = self.index
	MAX_ATTR_NUM.runeInfo = self.runeInfo
	SoraDSendMessage(MAX_ATTR_NUM)
	self:close()
end
return CheatRuneBuffPopPanel
