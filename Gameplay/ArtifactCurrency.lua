
Callback.add(Callback.TYPE.onPlayerInit, NAMESPACE.."ArtifactCurrency-onPlayerInit", function(player)
    player:get_data().ActiveArtifacts = {}
end)

gm.post_script_hook(gm.constants.add_item_pickup_display_for_player_gml_Object_oHUD_Create_0,
function(self, other, result, args)
        if other ~= nil and other.artifact_id ~= nil then
            local Artifact = Global.class_artifact[other.artifact_id + 1]
            table.insert(Instance.wrap(args[1].value):get_data().ActiveArtifacts, Artifact)
        end
    end)
