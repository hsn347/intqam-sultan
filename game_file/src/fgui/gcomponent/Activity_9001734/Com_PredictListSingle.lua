local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_PredictListSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001734/Com_PredictListSingle", Com_PredictListSingle)
local COM_NATINFO_SIZEH = 190
local QUESTION_BG_SIZEH = 50
function Com_PredictListSingle:onInit()
	self.fields.list_Question:setItemRenderer(handler(self, self.itemRenderer_List_Question))
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClickArrow))
	self.matchId = 0
	self:fixChildrenPos()
end
function Com_PredictListSingle:onShow()
end
function Com_PredictListSingle:initData(data)
	self.isOpen = false
	self.matchData = activity_9001734_Ctrl:getMatchData(data)
	if not self.matchData then
		return
	end
	self.matchId = self.matchData.id
	self.fields.com_natinfo:initData(self.matchId)
	self:updateQuestionList()
	activity_9001734_Ctrl = nil
	;(nil).time = _pq(fguiHelper.getColorString("#F0E6D2", SoraDConverTimeStr(self.matchData.endtime)))
	self.fields.text_tip:setString(i18n("champion_prediction_04", nil))
end
function Com_PredictListSingle:updateQuestionList()
	self.fields.Sprite_arr:setRotation(self.isOpen and 0 or SoraDFPosX(90, 0))
	if self.isOpen then
		self.fields.list_Question:setNumItems(#self.matchData.predictlist)
		self.fields.list_Question:resizeToFit(#self.matchData.predictlist)
		self.fields.img_bg:setVisible(true)
		self.fields.img_bg:setHeight(QUESTION_BG_SIZEH + self.fields.list_Question:getHeight())
	else
		self.fields.list_Question:setNumItems(0)
		self.fields.img_bg:setVisible(false)
	end
	self:setHeight(self.isOpen and QUESTION_BG_SIZEH + COM_NATINFO_SIZEH + self.fields.list_Question:getHeight() or COM_NATINFO_SIZEH)
end
function Com_PredictListSingle:updateQuestionSingle(title)
	for i = 1, self.fields.list_Question:getNumItems() do
		local obj = self.fields.list_Question:getChildAt(i - 1)
		if self.matchData.predictlist[i].title == title then
			obj:initData(self.matchData.predictlist[i], self.matchId)
		end
	end
end
function Com_PredictListSingle:itemRenderer_List_Question(index, obj)
	obj:initData(self.matchData.predictlist[index + 1], self.matchId)
end
function Com_PredictListSingle:btnClickArrow()
	SoraDPlaySound()
	self.isOpen = not self.isOpen
	self:updateQuestionList()
end
return Com_PredictListSingle
