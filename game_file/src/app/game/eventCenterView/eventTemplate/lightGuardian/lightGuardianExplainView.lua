local radianceWarRead = include("radianceWarRead")
local lightGuardianRead = include("lightGuardianRead")
local lightGuardianExplainView = class("lightGuardianExplainView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("lightGuardianExplainView")
end)
_UPVALUE3_ = "lightGuardianExplainView"
_UPVALUE3_, ("lightGuardianExplainView")[1] = "guardLight_text_14", "guardLight_text_14"
_UPVALUE3_, ("lightGuardianExplainView")[2] = "guardLight_text_14", "guardLight_text_15"
local _UPVALUE3_, ("lightGuardianExplainView")[3], titleConfig = "guardLight_text_14", "guardLight_text_16", "lightGuardianExplainView"
;("guardLight_text_14")[1] = "guardLight_text_18"
;("guardLight_text_14")[2] = "guardLight_text_19"
local ("guardLight_text_14")[3], typeNameConfig = "guardLight_text_20", "guardLight_text_14"
function lightGuardianExplainView:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("guardLight_text_13"))
	self.scroll = SoraDGetChildByName(self.node, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.nodeTitleList = SoraDGetChildsArrayByName(self, "Node_Title_", 3, 1, true)
	self.nodeSingleList = SoraDGetChildsArrayByName(self, "Node_Single_", 3, 1, true)
	self.nodeSingle = SoraDGetChildByName(self.node, "Node_Single")
	self:initData()
end
function lightGuardianExplainView:initData()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(550, 37), lightGuardianRead.getTypeScore_1(), 1, nil)
	self:initNodeTitle()
	self:initNodeSingleList()
end
function lightGuardianExplainView:initNodeTitle()
	local list = lightGuardianRead.getTypeScore_1()
	for i, v in ipairs(self.nodeTitleList) do
		lightGuardianRead = nil
		;(nil).num = string.formatnumberthousands(lightGuardianRead.getTypeScore_3().score)
		SoraDGetChildByName(v, "Text_Title"):setString(i18n(titleConfig[i], nil))
	end
end
function lightGuardianExplainView:initNodeSingleList()
	local list = lightGuardianRead.getTypeScore_2()
	for i, v in ipairs(self.nodeSingleList) do
		lightGuardianRead = nil
		;(nil).num1 = list[i].data
		;(nil).num2 = list[i].score
		SoraDGetChildByName(v, "Text_Num"):setString(i18n("guardLight_text_21", nil))
		SoraDGetChildByName(v, "Text_Name"):setString(i18n(typeNameConfig[i]))
	end
end
function lightGuardianExplainView:refreshScrollSingle(itemSingle, data)
	SoraDGetChildByName(itemSingle, "Image_Bg"):setVisible(data.id % 2 == 0)
	SoraDGetChildByName(itemSingle, "Text_Num"):setString(string.formatnumberthousands(data.score))
	SoraDGetChildByName(itemSingle, "Text_Name"):setString(radianceWarRead.getResourceName(data.data, true))
end
function lightGuardianExplainView:createScrollSingle()
	return self.nodeSingle:clone()
end
return lightGuardianExplainView
