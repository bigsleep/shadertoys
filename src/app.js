import React from 'react';
import ReactDOM from 'react-dom';
import * as THREE from 'three';

const fragmentShaderPrefix =`
uniform vec2 iResolution;
uniform float iTime;
uniform sampler2D iChannel0;
uniform vec2 iChannel0Size;
`;

const fragmentShaderPostfix =`
void main()
{
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
`;

const playerWidth = 500.0;
const playerHeight = 281.0;

const shaderNames = [
    "shaders/circle01.glsl",
    "shaders/wavycircle01.glsl",
    "shaders/wavycircle02.glsl",
    "shaders/perlinnoise01.glsl",
    "shaders/cubic01.glsl",
    "shaders/fragment01.glsl",
    "shaders/texture01.glsl",
    "shaders/vector-distance-field.glsl",
    "shaders/vector-distance-field-bicubic.glsl",
    "shaders/raymarching01.glsl",
    "shaders/raymarching02.glsl",
    "shaders/raymarching03.glsl",
    "shaders/raymarching04.glsl",
    "shaders/msdf01.glsl",
];

const textureNames = [
    "resources/circle-distance-field-32.png",
    "resources/circle-distance-field-64.png",
    "resources/circle-distance-field-128.png",
    "resources/low-resolution-circle.png",
    "resources/inconsolata-msdf.png",
];

const filterNames = [
    "Linear",
    "Nearest",
];

const filterTypes = [
    THREE.LinearFilter,
    THREE.NearestFilter,
];

const UniformTypes = {
    "i": "int",
    "f": "float",
    "v2": "vec2",
    "v3": "vec3",
    "v4": "vec4",
    "m4": "mat4",
    "t": "sampler2D"
};

function perspectiveMatrix(fovy, aspect, near, far) {
    const tanHalfFovy = Math.tan(0.5 * fovy);
    const x = 1.0 / (aspect * tanHalfFovy);
    const y = 1.0 / tanHalfFovy;
    const fpn = far + near;
    const fmn = far - near;
    const oon = 0.5 / near;
    const oof = 0.5 / far;
    const z = -fpn / fmn;
    const w = 1.0 / (oof - oon);
    const m = new THREE.Matrix4();
    m.set(
        x, 0.0, 0.0, 0.0,
        0.0, y, 0.0, 0.0,
        0.0, 0.0, z, -1.0,
        0.0, 0.0, w, 0.0);
    return m;
}

function invPerspectiveMatrix(fovy, aspect, near, far) {
    const t = Math.tan(0.5 * fovy);
    const a = aspect * t;
    const b = t;
    const c = 0.5 / (near - far);
    const d = 0.5 / (near + far);
    const m = new THREE.Matrix4();
    m.set(
        a, 0.0, 0.0, 0.0,
        0.0, b, 0.0, 0.0,
        0.0, 0.0, 0.0, c,
        0.0, 0.0, -1.0, d);
    return m;
}

function lookAtMatrix(eye, center, up) {
    const za = center.clone().sub(eye).normalize();
    const xa = up.clone().cross(za).normalize();
    const ya = za.clone().cross(xa);
    const xd = - xa.clone().dot(eye);
    const yd = - ya.clone().dot(eye);
    const zd = - za.clone().dot(eye);
    const m = new THREE.Matrix4();
    m.set(
        xa.x, ya.x, za.x, 0.0,
        xa.y, ya.y, za.y, 0.0,
        xa.z, ya.z, za.z, 0.0,
        xd, yd, zd, 1.0);
    return m;
}

function invLookAtMatrix() {
    const za = center.clone().sub(eye).normalize();
    const xa = up.clone().cross(za).normalize();
    const ya = za.clone().cross(xa);
    const xd = xa.clone().dot(eye);
    const yd = ya.clone().dot(eye);
    const zd = za.clone().dot(eye);
    const m = new THREE.Matrix4();
    m.set(
        xa.x, xa.y, xa.z, 0.0,
        ya.x, ya.y, ya.z, 0.0,
        za.x, za.y, za.z, 0.0,
        xd, yd, zd, 1.0);
    return m;
}

class ShaderViewer {
    constructor() {
        this.state = {
            fragmentShader: null,
            uniforms: {
                iTime: { type: "f", value: 0.0 },
                iResolution: { type: "v2", value: new THREE.Vector2(playerWidth, playerHeight) },
                iPerspective: { type: "m4", value: new THREE.Matrix4() },
                iInvPerspective: { type: "m4", value: new THREE.Matrix4() },
                iPerspectiveNear: { type: "f", value: 0.0 },
                iPerspectiveFar: { type: "f", value: 0.0 },
                iPerspectiveFovy: { type: "f", value: 0.0 },
            }
        }

        this.three = {};
        this.onUpdate = () => {}
    }

    buildUniformsHeader (uniforms) {
        return Object.keys(uniforms).map(key => {
            const typeName = UniformTypes[uniforms[key].type];
            return "uniform " + typeName + " " + key + ";\n";
        }).join("");
    }

    loadFragmentShader(shaderUrl) {
        const self = this;
        const uniformsHeader = this.buildUniformsHeader(this.state.uniforms);
        const buildShaderSrc = body => {
            return uniformsHeader + body + fragmentShaderPostfix;
        }
        const loader = new THREE.FileLoader();
        loader.mimeType = "x-shader/x-fragment";
        return new Promise(resolve => {
            loader.load(shaderUrl, content => {
                resolve(buildShaderSrc(content));
                self.state.fragmentShader = content;
                self.onUpdate(self.state);
            });
        });
    }

    loadTexture(textureUrl) {
        const loader = new THREE.TextureLoader();
        return new Promise(resolve => {
            loader.load(textureUrl, texture => {
                resolve(texture);
            });
        });
    }

    changeShader(shaderUrl) {
        const self = this;
        this.loadFragmentShader(shaderUrl)
            .then(fragmentShader => {
                self.three.material.fragmentShader = fragmentShader;
                self.three.material.needsUpdate = true;
            });
    }

    changeTexture(textureUrl) {
        const self = this;
        this.loadTexture(textureUrl)
            .then(texture => {
                texture.minFilter = this.state.uniforms.iChannel0.value.minFilter;
                texture.magFilter = this.state.uniforms.iChannel0.value.magFilter;
                self.state.uniforms.iChannel0.value = texture;
                self.state.uniforms.iChannel0Size.value = new THREE.Vector2(texture.image.width, texture.image.width);
                self.onUpdate(self.state);
            });
    }

    changeTextureMinFilter(filterType) {
        this.state.uniforms.iChannel0.value.minFilter = parseInt(filterType, 10);
        this.state.uniforms.iChannel0.value.needsUpdate = true;
        this.onUpdate(this.state);
    }

    changeTextureMagFilter(filterType) {
        this.state.uniforms.iChannel0.value.magFilter = parseInt(filterType, 10);
        this.state.uniforms.iChannel0.value.needsUpdate = true;
        this.onUpdate(this.state);
    }

    changePerspective(fovy, aspect, near, far) {
        this.state.uniforms.iPerspectiveFovy.value = fovy;
        this.state.uniforms.iPerspectiveNear.value = near;
        this.state.uniforms.iPerspectiveFar.value = far;
        this.state.uniforms.iPerspective.value = perspectiveMatrix(fovy, aspect, near, far);
        this.state.uniforms.iInvPerspective.value = invPerspectiveMatrix(fovy, aspect, near, far);
        this.onUpdate(this.state);
    }

    initialize(container, fragmentShaderUrl, textureUrl, onUpdate) {
        const self = this;
        this.onUpdate = onUpdate;
        this.loadFragmentShader(fragmentShaderUrl)
        .then(fragmentShader => {
            return self.loadTexture(textureUrl)
                .then(texture => {
                    return { fragmentShader : fragmentShader, texture : texture };
                });
        })
        .then(resource => {
            self.initializeThree(container, resource.fragmentShader, resource.texture);
        });
    }

    initializeThree(container, fragmentShader, texture) {
        this.state.uniforms.iChannel0 =  { type: "t", value: texture };
        this.state.uniforms.iChannel0Size = { type: "v2", value: new THREE.Vector2(texture.image.width, texture.image.width) };
        this.three.camera = new THREE.Camera();
        this.three.camera.position.z = 1;
        this.three.geometry = new THREE.PlaneBufferGeometry(2, 2);
        this.three.material = new THREE.ShaderMaterial({
            uniforms: this.state.uniforms,
            vertexShader: document.getElementById('vertexShader').textContent,
            fragmentShader: fragmentShader
        });
        this.three.mesh = new THREE.Mesh(this.three.geometry, this.three.material);
        this.three.scene = new THREE.Scene;
        this.three.scene.add(this.three.mesh);

        this.three.renderer = new THREE.WebGLRenderer();
        this.three.renderer.setSize(500, 281);
        this.three.renderer.setPixelRatio(window.devicePixelRatio);
        container.appendChild(this.three.renderer.domElement);

        this.animate();
    }

    animate() {
        const self = this;
        const callback = () => { self.animate() }
        requestAnimationFrame(callback);
        this.render();
    }

    render() {
        this.state.uniforms.iTime.value += 0.05;
        this.three.renderer.render(this.three.scene, this.three.camera);
        this.onUpdate(this.state);
    }
}

class ShaderViewerComponent extends React.Component {
    render() {
        return (
            <div>
                <div>
                    <label>
                        fragment shader <Select optionValues={shaderNames} optionNames={shaderNames} onChange={selected => this.props.shaderViewer.changeShader(selected)} />
                    </label>
                    <label>
                        texture <Select optionValues={textureNames} optionNames={textureNames} onChange={selected => this.props.shaderViewer.changeTexture(selected)} />
                    </label>
                    <label>
                        min filter <Select optionValues={filterTypes} optionNames={filterNames} onChange={selected => this.props.shaderViewer.changeTextureMinFilter(selected)} />
                    </label>
                    <label>
                        mag filter <Select optionValues={filterTypes} optionNames={filterNames} onChange={selected => this.props.shaderViewer.changeTextureMagFilter(selected)} />
                    </label>
                    <PerspectiveEditor onChange={this.props.shaderViewer.changePerspective.bind(this.props.shaderViewer)} />
                </div>
                <Player shaderViewer={this.props.shaderViewer} />
            </div>
        );
    }
}

class PerspectiveEditor extends React.Component {
    constructor () {
        super();
        this.state = {
            fovy: 0.5 * Math.PI,
            aspect: playerWidth / playerHeight,
            near: 0.0,
            far: 100.0
        };
    }

    componentDidMount() {
       this.props.onChange(this.state.fovy, this.state.aspect, this.state.near, this.state.far);
    }

    render() {
        const minFovy = Math.PI / 3.0;
        const maxFovy = Math.PI;
        const stepFovy = (maxFovy - minFovy) / 100.0;
        const minNear = 0.0;
        const maxNear = 10.0;
        const stepNear = (maxNear - minNear) / 100.0;
        const minFar = 10.0;
        const maxFar = 100.0;
        const stepFar = (maxFar - minFar) / 100.0;

        const onChangeFovy = e => {
            const value = parseFloat(e.target.value);
            this.state.fovy = value;
            this.props.onChange(this.state.fovy, this.state.aspect, this.state.near, this.state.far);
            this.setState(this.state);
        }

        const onChangeNear = e => {
            const value = parseFloat(e.target.value);
            this.state.near = value;
            this.props.onChange(this.state.fovy, this.state.aspect, this.state.near, this.state.far);
            this.setState(this.state);
        }

        const onChangeFar = e => {
            const value = parseFloat(e.target.value);
            this.state.far = value;
            this.props.onChange(this.state.fovy, this.state.aspect, this.state.near, this.state.far);
            this.setState(this.state);
        }

        return (
            <div>
                <label>
                    fovy <input type="range" value={this.state.fovy} onChange={onChangeFovy} min={minFovy} max={maxFovy} step={stepFovy} />
                </label>
                <label>
                    near <input type="range" value={this.state.near} onChange={onChangeNear} min={minNear} max={maxNear} step={stepNear} />
                </label>
                <label>
                    far <input type="range" value={this.state.far} onChange={onChangeFar} min={minFar} max={maxFar} step={stepFar} />
                </label>
            </div>
        );
    }
}

class Player extends React.Component {
    componentDidMount() {
        this.props.shaderViewer.initialize(this.container, shaderNames[0], textureNames[0], this.setState.bind(this));
    }

    render() {
        return <div className="player" ref={thisNode => {this.container = thisNode}}></div>;
    }
}

class Select extends React.Component {
    render() {
        const options = this.props.optionValues.map((value, index) => {
            return (<option key={index} value={value}>{this.props.optionNames[index]}</option>);
        });

        const onChange = e => {
            const options = e.target.options;
            const value = options[e.target.selectedIndex].value;
            this.props.onChange(value);
        }

        return (<select onChange={onChange}>{options}</select>);
    }
}

const shaderViewer = new ShaderViewer;
ReactDOM.render(<ShaderViewerComponent shaderViewer={shaderViewer} />, document.getElementById('root'));
