local newKingTrailAwardSingle = class("newKingTrailAwardSingle", function(target)
	return target
end)
function newKingTrailAwardSingle:ctor()
	self.itemArray, _ENV = nil, nil
	self.awardNode = SoraDGetChildByName(self, "Node_Award", true)
	self.textTitle = SoraDGetChildByName(self, "Text_propTitle", true)
end
function newKingTrailAwardSingle:initData(data, otherData)
	self.view = otherData.view
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local reward = serviceFunctions.tableFormat(data.reward, nil)
	for k, v in ipairs(reward) do
		if not self.itemArray[k] then
			self.itemArray[k] = include("commonItemAward").new()
			self.itemArray[k]:setScale(0.8)
			self.itemArray[k]:setBaseScale(1.0)
			self.itemArray[k]:setPosition(0, 0)
			self.itemArray[k]:setOwnView(self.view)
			self.itemArray[k]:addTo(self.awardNode)
		end
		self.itemArray[k]:setVisible(true)
		self.itemArray[k]:initData(v.id, v.count)
	end
	for i = #self.itemArray, #reward + 1, -1 do
		if self.itemArray[i] then
			self.itemArray[i]:setVisible(false)
		end
	end
	SoraDToCenter(self.awardNode, 90, SoraDFIsRA())
	local rankName = data.rank[1] == data.rank[2] and data.rank[1] or data.rank[1] .. "-" .. data.rank[2]
	_ENV = SoraDFIsRA()
	SoraDFIsRA().num = rankName
	self.textTitle:setString(i18n("common_text_617", SoraDFIsRA()))
end
return newKingTrailAwardSingle
