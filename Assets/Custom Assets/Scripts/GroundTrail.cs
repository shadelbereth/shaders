using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GroundTrail : MonoBehaviour {

    public float maxDistance = 0.1f;
    public float trailWidth = 0.2f;
    public float uvTiling = 8f;
    public Transform movingTarget;

    private List<Vector3> trailingPoints = new List<Vector3>();
    private Mesh trail;
    private MeshFilter meshFilter;
    private MeshRenderer meshRenderer;

	// Use this for initialization
	void Start () {
	   trailingPoints.Add(movingTarget.position);
        meshFilter = gameObject.GetComponent<MeshFilter>();
        if (meshFilter == null) {
            meshFilter = gameObject.AddComponent<MeshFilter>();
        }
        meshRenderer = gameObject.GetComponent<MeshRenderer>();
        if (meshRenderer == null) {
            meshRenderer = gameObject.AddComponent<MeshRenderer>();
        }
	}

    void GenerateMesh() {
        if (trail != null) {
            Destroy(trail);
        }
        trail = new Mesh();

        int numVertices = 2 * trailingPoints.Count;
        int numTriangles = 2 * (trailingPoints.Count - 1);
        Vector3[] vertices = new Vector3[numVertices];
        Vector3[] normals = new Vector3[numVertices];
        Vector2[] uvs = new Vector2[numVertices];
        Color[] colors = new Color[numVertices];
        int[] triangles = new int[numTriangles * 3];

        for (int i = 1; i < trailingPoints.Count; i++) {
            Vector3 trailDirection = trailingPoints[i] - trailingPoints[i-1];
            trailDirection.y = 0f;
            trailDirection.Normalize();
            Vector3 pointOffset = new Vector3(trailDirection.x, 0f, trailDirection.z) * trailWidth;
            if (i == 1) {
                vertices[0] = trailingPoints[0] - transform.position + pointOffset;
                vertices[1] = trailingPoints[0] - transform.position - pointOffset;
                normals[0] = Vector3.up;
                normals[1] = Vector3.up;
                uvs[0] = new Vector2(0f, 0f);
                uvs[1] = new Vector2(0f, 1f);
            }
            vertices[i*2] = trailingPoints[i] - transform.position + pointOffset;
            vertices[i*2 + 1] = trailingPoints[i] - transform.position - pointOffset;

            normals[i*2] = Vector3.up;
            normals[i*2 + 1] = Vector3.up;

            uvs[i*2] = new Vector2((float) i / uvTiling, 0f);
            uvs[i*2 + 1] = new Vector2((float) i / uvTiling, 1f);

            triangles[(i-1) * 6] = (i - 1) * 2 + 1;
            triangles[(i-1) * 6 + 1] = (i - 1) * 2 + 3;
            triangles[(i-1) * 6 + 2] = (i - 1) * 2 + 2;

            triangles[(i-1) * 6 + 3] = (i - 1) * 2 + 1;
            triangles[(i-1) * 6 + 4] = (i - 1) * 2 + 2;
            triangles[(i-1) * 6 + 5] = (i - 1) * 2 + 3;
        }
        trail.vertices = vertices;
        trail.normals = normals;
        trail.uv = uvs;
        trail.colors = colors;
        trail.triangles = triangles;

        meshFilter.mesh = trail;
    }
	
	// Update is called once per frame
	void Update () {
	   Vector3 deltaPosition = movingTarget.position - trailingPoints[trailingPoints.Count - 1];

       if (deltaPosition.magnitude > maxDistance) {
            trailingPoints.Add(movingTarget.position);
            GenerateMesh();
       }
	}
}
