local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsUtil = include("royalSummonsUtil")
local dashToSkyTaskSingle = class("dashToSkyTaskSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("dashToSkyTaskSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
function dashToSkyTaskSingle:ctor()
	self.itemNode = SoraDGetChildByName(self, "item_node")
	self.finishNode = SoraDGetChildByName(self, "Node_Finish")
	self.finishNode:setVisible(false)
	self.textFinish = SoraDGetChildByName(self, "Text_Finish")
	self.textFinish:setString(i18n("common_text_2601"))
end
function dashToSkyTaskSingle:initData(data, otherData)
	if otherData then
		self.mainView = otherData.mainView
	end
	local taskID = data.taskID
	data.count = royalSummonsUtil:getTaskProgress(taskID)
	data.total = royalSummonsUtil:getTaskAmount(taskID)
	self.data = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
		self.scroll = otherData.scroll
		self.activityID = otherData.activityID
	end
	local lang = self.data.taskDes[1]
	if not lang or lang == "" then
		dump(self.data, "commonTaskSingle:initData_imp")
		lang = "NA"
	end
	local targetNum = self.data.taskDes.num
	self.Text_des:setColor(cc.c3b(255, 255, 255))
	royalSummonsUtil = cc.c3b(255, 255, 255)
	royalSummonsUtil, royalSummonsUtil, cc.c3b(255, 255, 255).num = cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).color = "#FFC864"
	royalSummonsUtil, (targetNum or "").num, cc.c3b(255, 255, 255).i = cc.c3b(255, 255, 255)
	;(targetNum or "").__default, cc.c3b(255, 255, 255).color = cc.c3b(255, 255, 255)
	local str_des = _G.i18n_html(lang, cc.c3b(255, 255, 255))
	self.Text_des:setString(str_des)
	self.taskStatus = self.data.taskStatus
	local count = self.data.count
	local total = self.data.total
	count = math.min(count, total)
	if total <= count and self.taskStatus == gBtnTargetStatusDef.GOT then
		local value = string.format("(%s/%s)", count, total)
		value = IsArClient and _pq(value) or value
		royalSummonsUtil = cc.c3b(255, 255, 255)
		royalSummonsUtil, royalSummonsUtil, cc.c3b(255, 255, 255).value = cc.c3b(255, 255, 255)
		royalSummonsUtil, cc.c3b(255, 255, 255).value, cc.c3b(255, 255, 255).color = cc.c3b(255, 255, 255)
		cc.c3b(255, 255, 255).__default, cc.c3b(255, 255, 255).color = cc.c3b(255, 255, 255)
		self.Text_schedule:setString(_G.i18n_html("complete_text_05", cc.c3b(255, 255, 255)))
	else
		if total <= count then
			royalSummonsUtil = count
			count.color = "#d7c39b"
			if count then
				goto lbl_135
			end
		end
		royalSummonsUtil = count
		count.color = "#CE0000"
		::lbl_135::
		local countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(count), count)
		royalSummonsUtil = total
		total.color = "#d7c39b"
		local totalStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(total), total)
		local value = string.format("(%s/%s)", countStr, totalStr)
		value = IsArClient and _pq(value) or value
		royalSummonsUtil = _G.i18n_html("complete_text_05", cc.c3b(255, 255, 255))
		royalSummonsUtil, royalSummonsUtil, _G.i18n_html("complete_text_05", cc.c3b(255, 255, 255)).value = _G.i18n_html("complete_text_05", cc.c3b(255, 255, 255))
		_G.i18n_html("complete_text_05", cc.c3b(255, 255, 255)).__default, _G.i18n_html("complete_text_05", cc.c3b(255, 255, 255)).color = _G.i18n_html("complete_text_05", cc.c3b(255, 255, 255))
		self.Text_schedule:setString(_G.i18n_html("complete_text_05", _G.i18n_html("complete_text_05", cc.c3b(255, 255, 255))))
	end
	self:setAwardOffsetY(60)
	self:setBtnStatus()
	self:setAward()
end
function dashToSkyTaskSingle:setBtnStatus()
	self.finishNode:setVisible(self.taskStatus == gBtnTargetStatusDef.GOT)
	self.Button_go:setTouchEnabled(self.taskStatus ~= gBtnTargetStatusDef.GOT)
	self.Button_go:setTitleText(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146") or "")
	self.Button_go:loadTextureNormal(self.taskStatus == gBtnTargetStatusDef.GO and "btn_yellow_small_01.png" or "btn_green_small_01.png", ccui.TextureResType.plistType)
	if self.taskStatus == gBtnTargetStatusDef.GO and royalSummonsUtil:isSpiceilTask(self.data) then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(self.taskStatus ~= gBtnTargetStatusDef.GOT)
	end
end
function dashToSkyTaskSingle:doAction()
	local taskID = self.data.taskID
	SoraDShowLoading(self.mainView)
	royalSummonsCtrl:reqActivityGetTaskReward(taskID)
end
function dashToSkyTaskSingle:skipTo(taskDes)
	local data = self.data
	royalSummonsUtil:skipTo(data, taskDes)
end
return dashToSkyTaskSingle
