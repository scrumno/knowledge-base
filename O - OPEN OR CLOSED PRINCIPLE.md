bad example:
```jsx
const Button = ({ onPress, type, children }) => {
  let style = {};

  if (type === 'primary') {
    style = { backgroundColor: 'blue', color: 'white' };
  } else if (type === 'secondary') {
    style = { backgroundColor: 'gray', color: 'black' };
  }

  return (
    <TouchableOpacity onPress={onPress} style={style}>
      <Text>{children}</Text>
    </TouchableOpacity>
  );
};
```

good example:

```jsx
const Button = ({ onPress, style, children }) => {
  const defaultStyle = {
    padding: 10,
    borderRadius: 5,
  };

  return (
    <TouchableOpacity onPress={onPress} style={[defaultStyle, style]}>
      <Text>{children}</Text>
    </TouchableOpacity>
  );
};

// Now, you can extend the button's style without modifying the component itself
<Button style={{ backgroundColor: 'blue', color: 'white' }} onPress={handlePress}>
  Primary Button
</Button>

<Button style={{ backgroundColor: 'gray', color: 'black' }} onPress={handlePress}>
  Secondary Button
</Button>
```