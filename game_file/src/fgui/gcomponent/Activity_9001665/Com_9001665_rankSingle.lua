local baseComponent = require("fgui.base.baseComponent")
local Com_9001665_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001665/Com_9001665_rankSingle", Com_9001665_rankSingle)
function Com_9001665_rankSingle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
	self.fields.List_award:setItemRenderer(handler(self, self.onAwardItemRederer))
end
function Com_9001665_rankSingle:onShow()
end
function Com_9001665_rankSingle:initData(data, otheData)
	local rank = data.rank or otheData.index or 0
	_ENV = nil
	;(nil).rank = rank
	;(nil).uid = data.uid
	;(nil).isOwnRank = data.isOwnRank
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.fields.Com_rankBase.controllers.c_type:setSelectedIndex(otheData.bottom == 1 and 1 or 0)
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	local kid = data.kid or otheData.kid
	local nameStr = textParser.formatPlayerName(data.allianceAbbr, data.name, kid)
	self.fields.Text_name:setString(nameStr)
	self.fields.Text_score:setString(string.formatnumberthousands(data.score or 0))
	if otheData.rewards then
		self.awardList = otheData.rewards
		self.fields.List_award:setNumItems(#self.awardList)
	end
end
function Com_9001665_rankSingle:onAwardItemRederer(index, obj)
	local item = self.awardList[index + 1]
	obj:initData(item.id, item.count)
end
return Com_9001665_rankSingle
