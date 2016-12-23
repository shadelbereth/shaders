using UnityEngine;
using System.Collections;
using UnityEditor;

[CanEditMultipleObjects, CustomEditor(typeof(GrassGenerator))]
public class GrassGeneratorEditor : Editor {

	public override void OnInspectorGUI () {
        DrawDefaultInspector();
        if (GUILayout.Button("Rebuild grass")) {
            ((GrassGenerator) target).Generate();
        }
    }
}
