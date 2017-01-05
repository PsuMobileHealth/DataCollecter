package com.mbientlab.metawear.starter;

import android.opengl.GLES20;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.ShortBuffer;

/**
 * Created by toopazo on 22-12-2016.
 *
 */

//public class Triangle
public class GraphOpenglTriangle {
    private FloatBuffer vertexBuffer;

    // number of coordinates per vertex in this array
    static final int COORDS_PER_VERTEX = 4;
    static float triangleCoords[] = {   // in counterclockwise order:
            +0.0f, +0.622008459f, +0.622008459f, // top
            -0.5f, -0.311004243f, -0.622008459f, // bottom left
            +0.5f, -0.311004243f, -0.622008459f,  // bottom right
            +0.1f, -0.311004243f, -0.622008459f  // bottom back
    };

    // Set color with red, green, blue and alpha (opacity) values
    float color[] = { 0.63671875f, 0.76953125f, 0.22265625f, 1.0f };

    private final String vertexShaderCode =
            "attribute vec4 vPosition;" +
            "void main() {" +
            "  gl_Position = vPosition;" +
            "}";

    private final String fragmentShaderCode =
            "precision mediump float;" +
            "uniform vec4 vColor;" +
            "void main() {" +
            "  gl_FragColor = vColor;" +
            "}";

    private final int mProgram;

    private int mPositionHandle;
    private int mColorHandle;

    private final int vertexCount = triangleCoords.length / COORDS_PER_VERTEX;
    private final int vertexStride = COORDS_PER_VERTEX * 4; // 4 bytes per vertex

    private ShortBuffer SindexBuffer;
    private short[] pathDrawOrder = {0,1};

    public void draw() {
        // Add program to OpenGL ES environment
        GLES20.glUseProgram(mProgram);

        // get handle to vertex shader's vPosition member
        mPositionHandle = GLES20.glGetAttribLocation(mProgram, "vPosition");

        // Enable a handle to the triangle vertices
        GLES20.glEnableVertexAttribArray(mPositionHandle);

        // Prepare the triangle coordinate data
        GLES20.glVertexAttribPointer(mPositionHandle, COORDS_PER_VERTEX,
                GLES20.GL_FLOAT, false,
                vertexStride, vertexBuffer);

        // get handle to fragment shader's vColor member
        mColorHandle = GLES20.glGetUniformLocation(mProgram, "vColor");

        // Set color for drawing the triangle
        GLES20.glUniform4fv(mColorHandle, 1, color, 0);

        //GLES20.glDrawElements(GLES20.GL_LINES, 1, GLES20.GL_UNSIGNED_SHORT, );

        // Draw the triangle
        //GLES20.glDrawArrays(GLES20.GL_TRIANGLES, 0, vertexCount);
        //short has 2 bytes
        short[] index = {0,1,2,1,3,2};
        ByteBuffer ibb = ByteBuffer.allocateDirect(index.length*2);
        ibb.order(ByteOrder.nativeOrder());
        SindexBuffer = ibb.asShortBuffer();
        SindexBuffer.put(index);
        SindexBuffer.position(0);
        GLES20.glDrawElements(GLES20.GL_LINES, pathDrawOrder.length, GLES20.GL_UNSIGNED_SHORT, SindexBuffer);

        // Disable vertex array
        GLES20.glDisableVertexAttribArray(mPositionHandle);
    }

    public GraphOpenglTriangle() {
        int vertexShader = GraphOpenglMyGLRenderer.loadShader(GLES20.GL_VERTEX_SHADER,
                vertexShaderCode);
        int fragmentShader = GraphOpenglMyGLRenderer.loadShader(GLES20.GL_FRAGMENT_SHADER,
                fragmentShaderCode);

        // create empty OpenGL ES Program
        mProgram = GLES20.glCreateProgram();

        // add the vertex shader to program
        GLES20.glAttachShader(mProgram, vertexShader);

        // add the fragment shader to program
        GLES20.glAttachShader(mProgram, fragmentShader);

        // creates OpenGL ES program executables
        GLES20.glLinkProgram(mProgram);

        // initialize vertex byte buffer for shape coordinates
        ByteBuffer bb = ByteBuffer.allocateDirect(
                // (number of coordinate values * 4 bytes per float)
                triangleCoords.length * 4);
        // use the device hardware's native byte order
        bb.order(ByteOrder.nativeOrder());

        // create a floating point buffer from the ByteBuffer
        vertexBuffer = bb.asFloatBuffer();
        // add the coordinates to the FloatBuffer
        vertexBuffer.put(triangleCoords);
        // set the buffer to read the first coordinate
        vertexBuffer.position(0);

    }

//    private final String vertexShaderCode =
//            "uniform mat4 uMVPMatrix;" +
//                    "attribute vec4 vPosition;" +
//                    "void main() {" +
//                    "  gl_Position = uMVPMatrix * vPosition;" +
//                    "}";
//
//    private final String fragmentShaderCode =
//            "precision mediump float;" +
//                    "uniform vec4 vColor;" +
//                    "void main() {" +
//                    "  gl_FragColor = vColor;" +
//                    "}";
//
//    private final FloatBuffer vertexBuffer;
//    private final ShortBuffer drawListBuffer;
//    private final int mProgram;
//    private int mPositionHandle;
//    private int mColorHandle;
//    private int mMVPMatrixHandle;
//
//    static final int COORDS_PER_VERTEX = 3;
//    private final int vertexStride = COORDS_PER_VERTEX * 4;
//
//    private float[] pathCords = {
//            0.3f, -0.3f, 0.3f,
//            0.5f, 0.3f, 0.0f
//    };
//    private short[] pathDrawOrder = {0, 1};
//    private float[] color = {1.0f, 0.0f, 0.0f, 1.0f};
//
//    public GraphOpenglTriangle() {
//        ByteBuffer bb = ByteBuffer.allocateDirect(pathCords.length * 4);
//        bb.order(ByteOrder.nativeOrder());
//        vertexBuffer = bb.asFloatBuffer();
//        vertexBuffer.put(pathCords);
//        vertexBuffer.position(0);
//
//        ByteBuffer dlb = ByteBuffer.allocateDirect(pathDrawOrder.length * 2);
//        dlb.order(ByteOrder.nativeOrder());
//        drawListBuffer = dlb.asShortBuffer();
//        drawListBuffer.put(pathDrawOrder);
//        drawListBuffer.position(0);
//
//        int vertexShader = GraphOpenglMyGLRenderer.loadShader(GLES20.GL_VERTEX_SHADER, vertexShaderCode);
//        int fragmentShader = GraphOpenglMyGLRenderer.loadShader(GLES20.GL_FRAGMENT_SHADER, fragmentShaderCode);
//
//        mProgram = GLES20.glCreateProgram();
//        GLES20.glAttachShader(mProgram, vertexShader);
//        GLES20.glAttachShader(mProgram, fragmentShader);
//        GLES20.glLinkProgram(mProgram);
//    }
//
//    public void draw(float[] mvpMatrix) {
//
//        GLES20.glUseProgram(mProgram);
//        mPositionHandle = GLES20.glGetAttribLocation(mProgram, "vPosition");
//        GLES20.glEnableVertexAttribArray(mPositionHandle);
//        GLES20.glVertexAttribPointer(mPositionHandle, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false,
//                vertexStride, vertexBuffer);
//
//        mColorHandle = GLES20.glGetUniformLocation(mProgram, "vColor");
//        GLES20.glUniform4fv(mColorHandle, 1, color, 0);
//        mMVPMatrixHandle = GLES20.glGetUniformLocation(mProgram, "uMVPMatrix");
//        GLES20.glUniformMatrix4fv(mMVPMatrixHandle, 1, false, mvpMatrix, 0);
//
//        GLES20.glDrawElements(GLES20.GL_LINES, pathDrawOrder.length,
//                GLES20.GL_UNSIGNED_SHORT, drawListBuffer);
//
//        GLES20.glDisableVertexAttribArray(mPositionHandle);
//        GLES20.glDisable(mColorHandle);
//    }
}
