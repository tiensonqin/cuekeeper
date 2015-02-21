(* Copyright (C) 2015, Thomas Leonard
 * See the README file for details. *)

type uuid = string

module type MODEL = sig
  type t
  type 'a full_node

  type project_details
  type action_details

  type action = [`Action of action_details]
  type project = [`Project of project_details]
  type area = [`Area]

  type node_view = {
    uuid : uuid;
    node_type : [ `Area | `Project | `Action ] React.S.t;
    ctime : float;
    name : string React.S.t;
    child_views : node_view ReactiveData.RList.t;
  }

  type details = {
    details_uuid : uuid;
    details_type : [ `Area | `Project | `Action ] React.S.t;
    details_name : string React.S.t;
    details_description : string React.S.t;
    details_children : node_view ReactiveData.RList.t;
  }

  val root : t -> [area] full_node React.S.t

  val all_areas_and_projects : t -> (string * [> area | project] full_node) list

  val name : _ full_node -> string
  val uuid : _ full_node -> string

  val actions : [< area | project] full_node -> [action] full_node list
  val projects : [< area | project] full_node -> [project] full_node list
  val areas : [area] full_node -> [area] full_node list

  val add_action : t -> parent:uuid -> name:string -> description:string -> unit Lwt.t
  val add_project : t -> parent:uuid -> name:string -> description:string -> unit Lwt.t
  val add_area : t -> parent:uuid -> name:string -> description:string -> unit Lwt.t

  val set_name : t -> [< area | action | project] full_node -> string -> unit Lwt.t

  val process_tree : t -> node_view
  val work_tree : t -> node_view ReactiveData.RList.t
  val details : t -> uuid -> details
end
